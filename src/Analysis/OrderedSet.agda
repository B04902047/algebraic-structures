
module Analysis.OrderedSet {A : Set} (_≈_ : A → A → Set) where

open import Basic.Setoid
open import Basic.Logic
open import Basic.Properties

open import Data.List renaming ([_] to List)


record IsOrderedSet (S : A → Set) (_≤_ : A → A → Set): Set₁ where
  field
    isSet      : IsSet _≈_ S
    ≤-anti-sym : AntiSymmetric _≈_ S _≤_
    ≤-trans    : Transitive _≤_ S
    ≤-connex   : Connex _≤_ S

  ≤-refl : Reflexive _≤_ S
  ≤-refl {x} x∈S = A∨A→A (≤-connex x∈S x∈S)

  ≤-max₂ : {x y : A} → S x → S y → A × ((x ≤ y) ⊎ (y ≤ x))
  ≤-max₂ {x} {y} x∈S y∈S = [ (λ x≤y → (y , inj₁ x≤y)) , (λ y≤x → (x , inj₂ y≤x)) ] (≤-connex x∈S y∈S)

  ≤-max₃ : {x y z : A} → S x → S y → S z
                      → A × ((x ≤ y) ⊎ (y ≤ x))
                          × ((y ≤ z) ⊎ (z ≤ y))
                          × ((z ≤ x) ⊎ (x ≤ z))
  ≤-max₃ {x} {y} {z} x∈S y∈S z∈S
    = [ (λ y≤z
        → [ (λ z≤x → (x , inj₂ (≤-trans y∈S z∈S x∈S y≤z z≤x) , inj₁ y≤z , inj₁ z≤x ))
          , (λ x≤z → (z , xy-sign , inj₁ y≤z , inj₂ x≤z))
          ] zx-sign
        )
      , (λ z≤y
        → [ (λ x≤y → (y , inj₁ x≤y , inj₂ z≤y , zx-sign))
          , (λ y≤x → (x , inj₂ y≤x , inj₂ z≤y , inj₁ (≤-trans z∈S y∈S x∈S z≤y y≤x)))
          ] xy-sign)
      ] yz-sign
    where yz-sign = proj₂ (≤-max₂ y∈S z∈S)
          zx-sign = proj₂ (≤-max₂ z∈S x∈S)
          xy-sign = proj₂ (≤-max₂ x∈S y∈S)

  open IsSet isSet public
    renaming
    ( refl   to ≈-refl
    ; sym    to ≈-sym
    ; trans  to ≈-trans
    ; coerce to ≈-coerce
    ; ap     to ≈-ap
    )

  ≈⊆≤ : {x y : A} → S x → S y → x ≈ y → x ≤ y
  ≈⊆≤ {x} {y} x∈S y∈S x≈y = ≈-coerce (_≤ y) y∈S x∈S (≈-sym x∈S y∈S x≈y) (≤-refl y∈S)

  _<_ : A → A → Set
  x < y = (x ≤ y) × ¬ (x ≈ y)

  _≥_ : A → A → Set
  x ≥ y = y ≤ x

  _>_ : A → A → Set
  x > y = (x ≥ y) × ¬ (x ≈ y)

  infix  4 _IsWeakerThan_
  infix  3 _≤-∎⟨_⟩
  infixr 2 _≤⟨_,_⟩_ _≤≈⟨_,_⟩_ _≈≤⟨_,_⟩_ _≈≤˘⟨_,_⟩_
  infix  1 ≤-begin_

  record _IsWeakerThan_ (x y : A) : Set where
    field
      1∈S  : S x
      2∈S  : S y
      1≤2 : x ≤ y

  ≤-begin_ : ∀ {x y} → x IsWeakerThan y → x ≤ y
  ≤-begin relTo = _IsWeakerThan_.1≤2 relTo

  _≤⟨_,_⟩_ : ∀ x {y z} → S x → x ≤ y → y IsWeakerThan z → x IsWeakerThan z
  _ ≤⟨ x∈S , x≤y ⟩ relTo
    = record {
          1∈S = x∈S
        ; 2∈S = z∈S
        ; 1≤2 = (≤-trans x∈S y∈S z∈S x≤y y≤z)
        }
      where
        y∈S = _IsWeakerThan_.1∈S relTo
        z∈S = _IsWeakerThan_.2∈S relTo
        y≤z = _IsWeakerThan_.1≤2 relTo

  _≤≈⟨_,_⟩_ : ∀ x {y z} → S x → x ≤ y → y IsEquivalentTo z → x IsWeakerThan z
  _ ≤≈⟨ x∈S , x≤y ⟩ relTo
    = record {
          1∈S = x∈S
        ; 2∈S = z∈S
        ; 1≤2 = (≤-trans x∈S y∈S z∈S x≤y y≤z)
        }
      where
        y∈S = _IsEquivalentTo_.1∈S relTo
        z∈S = _IsEquivalentTo_.2∈S relTo
        y≤z = ≈⊆≤ y∈S z∈S (_IsEquivalentTo_.1≤2 relTo)

  _≈≤⟨_,_⟩_ : ∀ x {y z} → S x → x ≈ y → y IsWeakerThan z → x IsWeakerThan z
  _ ≈≤⟨ x∈S , x≈y ⟩ relTo = _ ≤⟨ x∈S , x≤y ⟩ relTo
      where
        y∈S = _IsWeakerThan_.1∈S relTo
        x≤y = ≈⊆≤ x∈S y∈S x≈y

  _≈≤˘⟨_,_⟩_ : ∀ x {y z} → S x → y ≈ x → y IsWeakerThan z → x IsWeakerThan z
  _ ≈≤˘⟨ x∈S , y≈x ⟩ relTo = _ ≈≤⟨ x∈S , x≈y ⟩ relTo
      where
        y∈S = _IsWeakerThan_.1∈S relTo
        x≈y = (≈-sym y∈S x∈S y≈x)

  _≤-∎⟨_⟩ : ∀ x → S x → x IsWeakerThan x
  _ ≤-∎⟨ x∈S ⟩ = record {
                1∈S = x∈S
              ; 2∈S = x∈S
              ; 1≤2 = ≤-refl x∈S
              }

  trichotomy-1 : {x y : A} → S x → S y
                → (x < y) ↔ (¬ (x ≈ y) × ¬ (x > y))
  trichotomy-1 x∈S y∈S = ((λ x<y → (proj₂ x<y , λ x>y → (proj₂ x<y) (≤-anti-sym x∈S y∈S (proj₁ x<y) (proj₁ x>y)))) , λ x!≈y∧x!>y → [ (λ x≤y → (x≤y , proj₁ x!≈y∧x!>y )) , (λ x≥y → [ id , (λ _ → ⊥-elim (proj₂ x!≈y∧x!>y (x≥y , proj₁ x!≈y∧x!>y))) ] (≤-connex x∈S y∈S) , (λ x≈y → (proj₁ x!≈y∧x!>y) x≈y) ) ] (≤-connex x∈S y∈S))

  trichotomy-2 : {x y : A} → S x → S y
                → (x > y) ↔ (¬ (x ≈ y) × ¬ (x < y))
  trichotomy-2 x∈S y∈S = ((λ x>y → (proj₂ x>y , λ x<y → (proj₂ x>y) (≤-anti-sym x∈S y∈S (proj₁ x<y) (proj₁ x>y)))) , λ x!≈y∧x!<y → [ (λ x≤y → ([ (λ _ → ⊥-elim ((proj₂ x!≈y∧x!<y) ((x≤y , proj₁ x!≈y∧x!<y)))) , id ] (≤-connex x∈S y∈S) , proj₁ x!≈y∧x!<y)) , (λ x≤y → (x≤y , proj₁ x!≈y∧x!<y)) ]  (≤-connex x∈S y∈S) )

  trichotomy-3-1 : {x y : A} → S x → S y
                → (x ≈ y) → (¬ (x < y) × ¬ (x > y))
  trichotomy-3-1 x∈S y∈S = λ x≈y → ((λ x<y → (proj₂ x<y) x≈y) , (λ x>y → (proj₂ x>y) x≈y))

  trichotomy-3-2 : {x y : A} → S x → S y
                → (¬ (x < y) × ¬ (x > y)) → ¬ ¬ (x ≈ y)
  trichotomy-3-2 x∈S y∈S = λ x!<y∧x!>y → [ (λ x≤y x!≈y → (proj₁ x!<y∧x!>y) (x≤y , x!≈y) ) , ((λ x≥y x!≈y → (proj₂ x!<y∧x!>y) (x≥y , x!≈y) )) ] (≤-connex x∈S y∈S)

  ≤≈-trans : {x y z : A} → S x → S y → S z
            → x ≤ y → y ≈ z → x ≤ z
  ≤≈-trans {x} x∈S y∈S z∈S x≤y y≈z
    = ≈-coerce (x ≤_) y∈S z∈S y≈z x≤y

  <≈-trans : {x y z : A} → S x → S y → S z
            → x < y → y ≈ z → x < z
  <≈-trans {x} x∈S y∈S z∈S x<y y≈z
    = ≈-coerce (x <_) y∈S z∈S y≈z x<y


  ≈≤-trans : {x y z : A} → S x → S y → S z
            → x ≈ y → y ≤ z → x ≤ z
  ≈≤-trans {x} {y} {z} x∈S y∈S z∈S x≈y
    = ≈-coerce (_≤ z) y∈S x∈S (≈-sym x∈S y∈S x≈y)

  ≈<-trans : {x y z : A} → S x → S y → S z
            → x ≈ y → y < z → x < z
  ≈<-trans {x} {y} {z} x∈S y∈S z∈S x≈y
    = ≈-coerce (_< z) y∈S x∈S (≈-sym x∈S y∈S x≈y)

  ≤<-trans : {x y z : A} → S x → S y → S z
            → x ≤ y → y < z → x < z
  ≤<-trans x∈S y∈S z∈S x≤y (y≤z , y≉z) = (x≤z , x≉z)
    where x≤z = ≤-trans x∈S y∈S z∈S x≤y y≤z
          x≉z = λ x≈z → y≉z (≤-anti-sym y∈S z∈S y≤z (≈≤-trans z∈S x∈S y∈S (≈-sym x∈S z∈S x≈z) x≤y))

  <≤-trans : {x y z : A} → S x → S y → S z
            → x < y → y ≤ z → x < z
  <≤-trans x∈S y∈S z∈S (x≤y , x≉y) y≤z = (x≤z , x≉z)
    where x≤z = ≤-trans x∈S y∈S z∈S x≤y y≤z
          x≉z = λ x≈z → x≉y (≤-anti-sym x∈S y∈S x≤y (≤≈-trans y∈S z∈S x∈S y≤z (≈-sym x∈S z∈S x≈z)))

  ≤≈-sandwich : {x y z : A} → S x → S y → S z
              → x ≤ z → z ≤ y
              → x ≈ y
              → x ≈ z × z ≈ y
  ≤≈-sandwich x∈S y∈S z∈S x≤z z≤y x≈y = (x≈z , z≈y)
    where z≤x = ≤≈-trans z∈S y∈S x∈S z≤y (≈-sym x∈S y∈S x≈y)
          x≈z = ≤-anti-sym x∈S z∈S x≤z z≤x
          y≤z = ≈≤-trans y∈S x∈S z∈S (≈-sym x∈S y∈S x≈y) x≤z
          z≈y = ≤-anti-sym z∈S y∈S z≤y y≤z
