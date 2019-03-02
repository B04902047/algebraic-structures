
module Structure.Group
        {a ℓ} {A : Set a}
        (_≈_ : A → A → Set ℓ)  where

open import Structure.Properties _≈_
open import Structure.Monoid _≈_ public

open import Data.Product using (_×_; proj₁; proj₂; _,_)
open import Relation.Nullary using (¬_)
open import Level using (_⊔_)


record IsGroup (G : A → Set ℓ) (_∙_ : A → A → A)
                (ε : A) (_⁻¹ : A → A) : Set (a ⊔ ℓ) where
  field
    isMonoid   : IsMonoid G _∙_ ε
    _⁻¹-close : Closed₁ G _⁻¹
    ⁻¹-cong    : Congruent₁ G _⁻¹
    _⁻¹-inverse : Inverse G _∙_ ε _⁻¹

  open IsMonoid isMonoid public

  _⁻¹-inverseˡ : {x : A} → G x → ((x ⁻¹) ∙ x) ≈ ε
  x∈G ⁻¹-inverseˡ = proj₁ (x∈G ⁻¹-inverse)

  _⁻¹-inverseʳ : {x : A} → G x → (x ∙ (x ⁻¹)) ≈ ε
  x∈G ⁻¹-inverseʳ = proj₂ (x∈G ⁻¹-inverse)

  ∙-cancelˡ : {x y z : A} → G x → G y → G z
              →  (z ∙ x) ≈ (z ∙ y) → x ≈ y
  ∙-cancelˡ {x} {y} {z} x∈G y∈G z∈G z∙x≈z∙y
    = begin
      x
    ≈˘⟨ x∈G , ε-identityˡ x∈G ⟩
      ε ∙ x
    ≈˘⟨ ε-close ∙-close x∈G , ∙-congˡ (z⁻¹∈G ∙-close z∈G) ε-close x∈G (z∈G ⁻¹-inverseˡ) ⟩
      ((z ⁻¹) ∙ z) ∙ x
    ≈⟨ (z⁻¹∈G ∙-close z∈G) ∙-close x∈G , ∙-assoc z⁻¹∈G z∈G x∈G ⟩
      (z ⁻¹) ∙ (z ∙ x)
    ≈⟨ z⁻¹∈G ∙-close (z∈G ∙-close x∈G) , ∙-congʳ (z∈G ∙-close x∈G) (z∈G ∙-close y∈G) z⁻¹∈G z∙x≈z∙y ⟩
      (z ⁻¹) ∙ (z ∙ y)
    ≈˘⟨ z⁻¹∈G ∙-close (z∈G ∙-close y∈G) , ∙-assoc z⁻¹∈G z∈G y∈G ⟩
      ((z ⁻¹) ∙ z) ∙ y
    ≈⟨ (z⁻¹∈G ∙-close z∈G) ∙-close y∈G , ∙-congˡ (z⁻¹∈G ∙-close z∈G) ε-close y∈G (z∈G ⁻¹-inverseˡ) ⟩
      ε ∙ y
    ≈⟨ ε-close ∙-close y∈G , ε-identityˡ y∈G ⟩
      y
    ∎⟨ y∈G ⟩
    where z⁻¹∈G = z∈G ⁻¹-close

  ∙-cancelʳ : {x y z : A} → G x → G y → G z
              →  (x ∙ z) ≈ (y ∙ z) → x ≈ y
  ∙-cancelʳ {x} {y} {z} x∈G y∈G z∈G x∙z≈y∙z
    = begin
      x
    ≈˘⟨ x∈G , x∈G ε-identityʳ ⟩
      x ∙ ε
    ≈˘⟨ x∈G ∙-close ε-close , ∙-congʳ (z∈G ∙-close z⁻¹∈G) ε-close x∈G (z∈G ⁻¹-inverseʳ) ⟩
      x ∙ (z ∙ (z ⁻¹))
    ≈˘⟨ x∈G ∙-close (z∈G ∙-close z⁻¹∈G) , ∙-assoc x∈G z∈G z⁻¹∈G ⟩
      (x ∙ z) ∙ (z ⁻¹)
    ≈⟨ (x∈G ∙-close z∈G) ∙-close z⁻¹∈G , ∙-congˡ (x∈G ∙-close z∈G) (y∈G ∙-close z∈G) z⁻¹∈G x∙z≈y∙z ⟩
      (y ∙ z) ∙ (z ⁻¹)
    ≈⟨ (y∈G ∙-close z∈G) ∙-close z⁻¹∈G , ∙-assoc y∈G z∈G z⁻¹∈G ⟩
      y ∙ (z ∙ (z ⁻¹))
    ≈⟨ y∈G ∙-close (z∈G ∙-close z⁻¹∈G) , ∙-congʳ (z∈G ∙-close z⁻¹∈G) ε-close y∈G (z∈G ⁻¹-inverseʳ) ⟩
      y ∙ ε
    ≈⟨ y∈G ∙-close ε-close , y∈G ε-identityʳ ⟩
      y
    ∎⟨ y∈G ⟩
    where z⁻¹∈G = z∈G ⁻¹-close

  ⁻¹-uniqueˡ : {x y : A} → G x → G y → (x ∙ y) ≈ ε → x ≈ (y ⁻¹)
  ⁻¹-uniqueˡ {x} {y} x∈G y∈G x∙y≈ε
    = begin
        x
      ≈˘⟨ x∈G , x∈G ε-identityʳ ⟩
        x ∙ ε
      ≈⟨ x∈G ∙-close ε∈G , ∙-congʳ ε∈G (y∈G ∙-close y⁻¹∈G) x∈G (sym (y∈G ∙-close y⁻¹∈G) ε∈G (y∈G ⁻¹-inverseʳ)) ⟩
        x ∙ (y ∙ (y ⁻¹))
      ≈˘⟨ x∈G ∙-close (y∈G ∙-close y⁻¹∈G) , ∙-assoc x∈G y∈G y⁻¹∈G ⟩
        (x ∙ y) ∙ (y ⁻¹)
      ≈⟨ (x∈G ∙-close y∈G) ∙-close y⁻¹∈G , ∙-congˡ (x∈G ∙-close y∈G) ε∈G y⁻¹∈G x∙y≈ε ⟩
        ε ∙ (y ⁻¹)
      ≈⟨ ε∈G ∙-close y⁻¹∈G , ε-identityˡ y⁻¹∈G ⟩
        (y ⁻¹)
      ∎⟨ y⁻¹∈G ⟩
      where ε∈G = ε-close
            y⁻¹∈G = y∈G ⁻¹-close

  ⁻¹-uniqueʳ : {x y : A} → G x → G y → (x ∙ y) ≈ ε → y ≈ (x ⁻¹)
  ⁻¹-uniqueʳ {x} {y} x∈G y∈G x∙y≈ε
    = begin
        y
      ≈˘⟨ y∈G , ε-identityˡ y∈G ⟩
        ε ∙ y
      ≈˘⟨ ε∈G ∙-close y∈G , ∙-congˡ (x⁻¹∈G ∙-close x∈G) ε∈G y∈G (x∈G ⁻¹-inverseˡ) ⟩
        ((x ⁻¹) ∙ x) ∙ y
      ≈⟨ (x⁻¹∈G ∙-close x∈G) ∙-close y∈G , ∙-assoc x⁻¹∈G x∈G  y∈G ⟩
        (x ⁻¹) ∙ (x ∙ y)
      ≈⟨ x⁻¹∈G ∙-close (x∈G ∙-close y∈G) , ∙-congʳ (x∈G ∙-close y∈G) ε∈G x⁻¹∈G x∙y≈ε ⟩
        (x ⁻¹) ∙ ε
      ≈⟨ x⁻¹∈G ∙-close ε∈G , x⁻¹∈G ε-identityʳ ⟩
        (x ⁻¹)
      ∎⟨ x⁻¹∈G ⟩
      where ε∈G = ε-close
            x⁻¹∈G = x∈G ⁻¹-close

  _/_ : A → A → A
  x / y = x ∙ (y ⁻¹)

  _/-close_ : Closed₂ G _/_
  x∈G /-close y∈G = x∈G ∙-close (y∈G ⁻¹-close)

  /-congˡ : LeftCongruent G _/_
  /-congˡ {x} {y} {z} x∈G y∈G z∈G x≈y
    = begin
        x / z
      ≈⟨ x∈G /-close z∈G , ∙-congˡ x∈G y∈G (z∈G ⁻¹-close) x≈y ⟩
        y / z
      ∎⟨ y∈G /-close z∈G ⟩

  /-congʳ : RightCongruent G _/_
  /-congʳ {x} {y} {z} x∈G y∈G z∈G x≈y
    = begin
        z / x
      ≈⟨ z∈G /-close x∈G , ∙-congʳ (x∈G ⁻¹-close) (y∈G ⁻¹-close) z∈G (⁻¹-cong x∈G y∈G x≈y) ⟩
        z / y
      ∎⟨ z∈G /-close y∈G ⟩

record IsAbelianGroup (G : A → Set ℓ) (∙ : A → A → A)
                      (ε : A) (⁻¹ : A → A) : Set (a ⊔ ℓ) where
  field
    isGroup : IsGroup G ∙ ε ⁻¹
    ∙-comm    : Commutative G ∙

  open IsGroup isGroup public

  isCommutativeMonoid : IsCommutativeMonoid G ∙ ε
  isCommutativeMonoid = record
    { isSemigroup = isSemigroup
    ; ε-close     = ε-close
    ; ε-identityˡ = ε-identityˡ
    ; ∙-comm      = ∙-comm
    }
