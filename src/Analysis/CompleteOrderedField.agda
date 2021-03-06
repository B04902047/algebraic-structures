
module Analysis.CompleteOrderedField {A : Set} (_≈_ : A → A → Set) where

open import Analysis.OrderedField _≈_
open import Basic.Logic
open import Basic.Properties _≈_
open import Basic.Subtype

record IsCompleteOrderedField
        (ℝ : A → Set)
        (_+_ _*_ : A → A → A)
        (0# 1# : A) (- _⁻¹ : A → A)
        (_≤_ : A → A → Set) : Set₁ where
  field
    isOrderedField : IsOrderedField ℝ _+_ _*_ 0# 1# - _⁻¹ _≤_
    completeness   : IsOrderedField.MonotoneSequeceProperty isOrderedField

  open IsOrderedField isOrderedField public

  postulate
    cauchyCompleteness   : IsOrderedField.CauchyComplete isOrderedField

  data ℚ : A → Set where
    z∈ℚ : {z : A} → ℤ z → ℚ z
    z/n∈ℚ : {z n : A} → ℤ z → ℕ n → ℚ (z / n)
  postulate
    archimedean'  : {x y : A} → ℝ x → ℝ y → 0# < x → x < y
                  → Σ[ k ∈ A ] (ℕ k) × y < (k * x)

record IsCompleteOrderedField'
        (ℝ : A → Set)
        (_+_ _*_ : A → A → A)
        (0# 1# : A) (- _⁻¹ : A → A)
        (_≤_ : A → A → Set) : Set₁ where
  field
    isOrderedField : IsOrderedField ℝ _+_ _*_ 0# 1# - _⁻¹ _≤_
    cauchyCompleteness   : IsOrderedField.CauchyComplete isOrderedField

  open IsOrderedField isOrderedField public

  postulate
    completeness   : IsOrderedField.MonotoneSequeceProperty isOrderedField
