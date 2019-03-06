
module Structure.Monoid {a ℓ} {A : Set a}
        (_≈_ : A → A → Set ℓ) where

open import Structure.Properties _≈_
open import Structure.Semigroup _≈_ public
open import Structure.Subtype

open import Structure.Logic
open import Level using (_⊔_; suc)


record IsMonoid (M : A → Set ℓ) (_∙_ : A → A → A) (ε : A)
                                        : Set (a ⊔ suc ℓ) where
  field
    isSemigroup : IsSemigroup M _∙_
    ε-close     : Closed₀ M ε
    ε-identity  : Identity M _∙_ ε

  open IsSemigroup isSemigroup public

  ε-identityˡ : LeftIdentity M _∙_ ε
  ε-identityˡ = proj₁ ε-identity

  _ε-identityʳ : RightIdentity M _∙_ ε
  _ε-identityʳ = proj₂ ε-identity

  ε-uniqueˡ : {e : A} → M e → ({x : A} → M x → ((e ∙ x) ≈ x)) → (e ≈ ε)
  ε-uniqueˡ {e} e∈M λx∈M→e∙x≈x = begin
                          e
                        ≈˘⟨ e∈M , e∈M ε-identityʳ ⟩
                          e ∙ ε
                        ≈⟨ e∈M ∙-close ε-close , λx∈M→e∙x≈x ε-close ⟩
                          ε
                        ∎⟨ ε-close ⟩
  ε-uniqueʳ : {e : A} → M e → ({x : A} → M x → ((x ∙ e) ≈ x)) → (e ≈ ε)
  ε-uniqueʳ {e} e∈M λx∈M→x∙e≈x = begin
                          e
                        ≈˘⟨ e∈M , ε-identityˡ e∈M ⟩
                          ε ∙ e
                        ≈⟨ ε-close ∙-close e∈M , λx∈M→x∙e≈x ε-close ⟩
                          ε
                        ∎⟨ ε-close ⟩

record IsCommutativeMonoid
          (M : A → Set ℓ) (_∙_ : A → A → A) (ε : A)
                                      : Set (a ⊔ suc ℓ) where
  field
    isSemigroup : IsSemigroup M _∙_
    ε-close     : Closed₀ M ε
    ε-identityˡ : LeftIdentity M _∙_ ε
    ∙-comm      : Commutative M _∙_

  open IsSemigroup isSemigroup public

  -- postulate
  --   identityʳ : RightIdentity _∙_ ε
  --
  -- identity : Identity _∙_ ε
  -- identity = (identityˡ , identityʳ)
  --
  -- isMonoid : IsMonoid _∙_ ε
  -- isMonoid = record {
  --     isSemigroup = isSemigroup
  --   ; ε-close     = ε-close
  --   ; identity    = identity
  --   }

record IsIdempotentCommutativeMonoid
          (M : A → Set ℓ) (∙ : A → A → A) (ε : A)
                                      : Set (a ⊔ suc ℓ) where
  field
    isCommutativeMonoid : IsCommutativeMonoid M ∙ ε
    idem                : Idempotent M ∙

  open IsCommutativeMonoid isCommutativeMonoid public


record _IsSubmonoidOf_
        (N : A → Set ℓ) (M : A → Set ℓ)
        (_∙_ : A → A → A) (ε : A) : Set (a ⊔ suc ℓ) where
  field
    N⊆M        : N ⊆ M
    M-isMonoid : IsMonoid M _∙_ ε
    N-isMonoid : IsMonoid N _∙_ ε

record _IsSubmonoidOf'_
        (N : A → Set ℓ) (M : A → Set ℓ)
        (_∙_ : A → A → A) (ε : A) : Set (a ⊔ suc ℓ) where
  field
    N⊆M         : N ⊆ M
    M-isMonoid  : IsMonoid M _∙_ ε
    ε-close-N   : N ε
    _∙-close-N_ : Closed₂ N _∙_

  open IsMonoid M-isMonoid
    renaming (isSemigroup to M-isSemigroup)

  N-isSubsemigroupOf-M : (N IsSubsemigroupOf M) _∙_
  N-isSubsemigroupOf-M = record
    { T⊆S           = N⊆M
    ; S-isSemigroup = M-isSemigroup
    ; _∙-close-T_    = _∙-close-N_
    }

  N-isSemigroup : IsSemigroup N _∙_
  N-isSemigroup = _IsSubsemigroupOf_.T-isSemigroup N-isSubsemigroupOf-M

  ε-identityˡ-N : LeftIdentity N _∙_ ε
  ε-identityˡ-N x∈N = ε-identityˡ (N⊆M x∈N)

  _ε-identityʳ-N : RightIdentity N _∙_ ε
  x∈N ε-identityʳ-N  = (N⊆M x∈N) ε-identityʳ

  ε-identity-N : Identity N _∙_ ε
  ε-identity-N = (ε-identityˡ-N , _ε-identityʳ-N)

  N-isMonoid : IsMonoid N _∙_ ε
  N-isMonoid = record
    { isSemigroup = N-isSemigroup
    ; ε-close     = ε-close-N
    ; ε-identity  = ε-identity-N
    }
