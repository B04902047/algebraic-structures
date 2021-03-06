
module Algebra.Ring {A : Set} (_≈_ : A → A → Set) where

open import Algebra.Group _≈_ public

open import Basic.Logic
open import Basic.Properties _≈_


record IsRing (R : A → Set) (_+_ _*_ : A → A → A)
          (0# 1# : A) (-_ : A → A) : Set₁ where
  field
    +-isAbelianGroup : IsAbelianGroup R _+_ 0# -_
    *-isMonoid       : IsMonoid R _*_ 1#
    distrib          : _DistributesOver_ R _*_ _+_

  distribˡ : _DistributesOverˡ_ R _*_ _+_
  distribˡ = proj₁ distrib

  distribʳ : _DistributesOverʳ_ R _*_ _+_
  distribʳ = proj₂ distrib

  open IsAbelianGroup +-isAbelianGroup public
    renaming
    ( _∙-comm_            to _+-comm_
    ; isGroup             to +-isGroup
    ;   _⁻¹-close         to -‿close
    ;   _⁻¹-inverse       to -‿inverse
    ;     _⁻¹-inverseˡ    to -‿inverseˡ
    ;     _⁻¹-inverseʳ    to -‿inverseʳ
    ;   ⁻¹-cong           to -‿cong
    ;     ⁻¹-uniqueˡ      to -‿uniqueˡ
    ;     ⁻¹-uniqueʳ      to -‿uniqueʳ
    ;     ⁻¹-doubleInverse to -‿doubleInverse
    ;     ∙-cancelˡ       to +-cancelˡ
    ;     ∙-cancelʳ       to +-cancelʳ
    ;     _/_             to _-_
    ;     _/-close_       to _-‿close_
    ;     /-congˡ         to -‿congˡ
    ;     /-congʳ         to -‿congʳ
    ;   isMonoid          to +-isMonoid
    ;     ε∈G             to 0∈R
    ;     ε-identity      to 0-identity
    ;       ε-identityˡ   to 0-identityˡ
    ;       _ε-identityʳ  to _0-identityʳ
    ;       ε-uniqueˡ     to 0-uniqueˡ
    ;       ε-uniqueʳ     to 0-uniqueʳ
    ;     isSemigroup     to +-isSemigroup
    ;       ∙-assoc       to +-assoc
    ;       isMagma       to +-isMagma
    ;         _∙-close_   to _+-close_
    ;         ∙-congˡ     to +-congˡ
    ;         ∙-congʳ     to +-congʳ
    ;         ∙-sum       to +-sum
    ; isCommutativeMonoid to +-isCommutativeMonoid
    )

  open IsMonoid *-isMonoid public
    using ()
    renaming
    ( ε∈M             to 1∈R
    ; ε-identity      to 1-identity
    ;   ε-identityˡ   to 1-identityˡ
    ;   _ε-identityʳ  to _1-identityʳ
    ;   ε-uniqueˡ     to 1-uniqueˡ
    ;   ε-uniqueʳ     to 1-uniqueʳ
    ; isSemigroup     to *-isSemigroup
    ;   ∙-assoc       to *-assoc
    ;   isMagma       to *-isMagma
    ;     _∙-close_   to _*-close_
    ;     ∙-congˡ     to *-congˡ
    ;     ∙-congʳ     to *-congʳ
    ;     ∙-sum       to *-sum
    )

  0-zeroˡ : LeftZero R _*_ 0#
  0-zeroˡ {x} x∈R =
    begin
      0# * x
    ≈˘⟨ 0*x∈R , 0*x∈R 0-identityʳ ⟩
      (0# * x) + 0#
    ≈˘⟨ 0*x∈R +-close 0∈R , +-congʳ (0*x∈R +-close -0*x∈R) 0∈R 0*x∈R (-‿inverseʳ 0*x∈R) ⟩
      (0# * x) + ((0# * x) - (0# * x))
    ≈˘⟨ 0*x∈R +-close (0*x∈R +-close -0*x∈R) , (+-assoc 0*x∈R 0*x∈R -0*x∈R) ⟩
      ((0# * x) + (0# * x)) - (0# * x)
    ≈˘⟨ (0*x∈R +-close 0*x∈R) +-close -0*x∈R , +-congˡ ((0∈R +-close 0∈R) *-close x∈R) (0*x∈R +-close 0*x∈R) -0*x∈R (distribʳ x∈R 0∈R 0∈R) ⟩
      ((0# + 0#) * x) - (0# * x)
    ≈⟨ ((0∈R +-close 0∈R) *-close x∈R) +-close -0*x∈R , +-congˡ ((0∈R +-close 0∈R) *-close x∈R) 0*x∈R -0*x∈R (*-congˡ (0∈R +-close 0∈R) 0∈R x∈R (0∈R 0-identityʳ)) ⟩
      (0# * x) - (0# * x)
    ≈⟨ 0*x∈R +-close -0*x∈R , -‿inverseʳ 0*x∈R ⟩
      0#
    ∎⟨ 0∈R ⟩
    where 0*x∈R  = 0∈R *-close x∈R
          -0*x∈R = -‿close 0*x∈R

  _0-zeroʳ : RightZero R _*_ 0#
  _0-zeroʳ {x} x∈R =
    begin
      x * 0#
    ≈˘⟨ x*0∈R , x*0∈R 0-identityʳ ⟩
      (x * 0#) + 0#
    ≈˘⟨ x*0∈R +-close 0∈R , +-congʳ (x*0∈R +-close -x*0∈R) 0∈R x*0∈R ((-‿inverseʳ x*0∈R)) ⟩
      (x * 0#) + ((x * 0#) - (x * 0#))
    ≈˘⟨ x*0∈R +-close (x*0∈R +-close -x*0∈R) , (+-assoc x*0∈R x*0∈R -x*0∈R) ⟩
      ((x * 0#) + (x * 0#)) - (x * 0#)
    ≈˘⟨ (x*0∈R +-close x*0∈R) +-close -x*0∈R , +-congˡ (x∈R *-close (0∈R +-close 0∈R)) (x*0∈R +-close x*0∈R) -x*0∈R (distribˡ x∈R 0∈R 0∈R) ⟩
      (x * (0# + 0#)) - (x * 0#)
    ≈⟨ (x∈R *-close (0∈R +-close 0∈R) ) +-close -x*0∈R , +-congˡ (x∈R *-close (0∈R +-close 0∈R) ) x*0∈R -x*0∈R (*-congʳ (0∈R +-close 0∈R) 0∈R x∈R (0-identityˡ 0∈R)) ⟩
      (x * 0#) - (x * 0#)
    ≈⟨ x*0∈R +-close -x*0∈R , -‿inverseʳ x*0∈R ⟩
      0#
    ∎⟨ 0∈R ⟩
    where x*0∈R  = x∈R *-close 0∈R
          -x*0∈R = -‿close x*0∈R

  negativeUnit : {x : A} → R x → ((- 1#) * x) ≈ (- x)
  negativeUnit {x} x∈R
    = begin
      (- 1#) * x
    ≈˘⟨ -1*x∈R , -1*x∈R 0-identityʳ ⟩
      ((- 1#) * x) + 0#
    ≈˘⟨ -1*x∈R +-close 0∈R , +-congʳ (x∈R +-close -x∈R) 0∈R -1*x∈R (-‿inverseʳ x∈R) ⟩
      ((- 1#) * x) + (x - x)
    ≈˘⟨ -1*x∈R +-close (x∈R +-close -x∈R) , +-assoc -1*x∈R x∈R -x∈R ⟩
      (((- 1#) * x) + x) - x
    ≈˘⟨ (-1*x∈R +-close x∈R) +-close -x∈R , -‿congˡ (-1*x∈R +-close 1*x∈R) (-1*x∈R +-close x∈R) x∈R (+-congʳ 1*x∈R x∈R -1*x∈R (1-identityˡ x∈R)) ⟩
      (((- 1#) * x) + (1# * x)) - x
    ≈˘⟨ (-1*x∈R +-close 1*x∈R) +-close -x∈R , -‿congˡ ((-1∈R +-close 1∈R) *-close x∈R) (-1*x∈R +-close 1*x∈R) x∈R (distribʳ x∈R -1∈R 1∈R) ⟩
      (((- 1#) + 1#) * x) - x
    ≈⟨ ((-1∈R +-close 1∈R) *-close x∈R) +-close -x∈R , -‿congˡ ((-1∈R +-close 1∈R) *-close x∈R) (0∈R *-close x∈R) x∈R (*-congˡ (-1∈R +-close 1∈R) 0∈R x∈R (-‿inverseˡ 1∈R)) ⟩
      (0# * x) - x
    ≈⟨ (0∈R *-close x∈R) +-close -x∈R , -‿congˡ (0∈R *-close x∈R) 0∈R x∈R (0-zeroˡ x∈R) ⟩
      0# - x
    ≈⟨ 0∈R +-close -x∈R , 0-identityˡ -x∈R ⟩
      - x
    ∎⟨ -‿close x∈R ⟩
    where -1∈R = -‿close 1∈R
          -x∈R = -‿close x∈R
          1*x∈R = 1∈R *-close x∈R
          -1*x∈R = -1∈R *-close x∈R

  negativeZero : (- 0#) ≈ 0#
  negativeZero = begin
                - 0#
              ≈˘⟨ -‿close 0∈R , negativeUnit 0∈R ⟩
                (- 1#) * 0#
              ≈⟨ (-‿close 1∈R) *-close 0∈R , (-‿close 1∈R) 0-zeroʳ ⟩
                0#
              ∎⟨ 0∈R ⟩

  -- postulate
  --   zeroRing : (1# ≈ 0#) → (a : A) → (¬ (¬ (a ≈ 1#)))
  -‿assoc : {x y : A} → R x → R y → ((- x) * y) ≈ (- (x * y))
  -‿assoc {x} {y} x∈R y∈R = begin
                            (- x) * y
                          ≈˘⟨ (-‿close x∈R) *-close y∈R , *-congˡ ((-‿close 1∈R) *-close x∈R) (-‿close x∈R) y∈R (negativeUnit x∈R) ⟩
                            ((- 1#) * x) * y
                          ≈⟨ ((-‿close 1∈R) *-close x∈R) *-close y∈R , *-assoc (-‿close 1∈R) x∈R y∈R ⟩
                            ((- 1#) * (x * y))
                          ≈⟨ (-‿close 1∈R) *-close (x∈R *-close y∈R) , negativeUnit (x∈R *-close y∈R) ⟩
                            - (x * y)
                          ∎⟨ -‿close (x∈R *-close y∈R) ⟩
  -‿distrib : {x y : A} → R x → R y → (- (x + y)) ≈ ((- x) + (- y))
  -‿distrib {x} {y} x∈R y∈R = begin
                              - (x + y)
                            ≈˘⟨ -‿close (x∈R +-close y∈R) , negativeUnit (x∈R +-close y∈R) ⟩
                              (- 1#) * (x + y)
                            ≈⟨ (-‿close 1∈R) *-close (x∈R +-close y∈R) , distribˡ (-‿close 1∈R) x∈R y∈R ⟩
                              ((- 1#) * x) + ((- 1#) * y)
                            ≈⟨ ((-‿close 1∈R) *-close x∈R) +-close ((-‿close 1∈R) *-close y∈R) , +-congˡ ((-‿close 1∈R) *-close x∈R) (-‿close x∈R) ((-‿close 1∈R) *-close y∈R) (negativeUnit x∈R) ⟩
                              (- x) + ((- 1#) * y)
                            ≈⟨ (-‿close x∈R) +-close ((-‿close 1∈R) *-close y∈R) , +-congʳ ((-‿close 1∈R) *-close y∈R) (-‿close y∈R) (-‿close x∈R) (negativeUnit y∈R) ⟩
                              (- x) + (- y)
                            ∎⟨ (-‿close x∈R) +-close (-‿close y∈R) ⟩

record IsCommutativeRing (R : A → Set) (+ * : A → A → A)
                         (0# 1# : A) (- : A → A) : Set₁ where
  field
    isRing   : IsRing R + * 0# 1# -
    _*-comm_ : Commutative R *

  open IsRing isRing public

  *-isCommutativeMonoid : IsCommutativeMonoid R * 1#
  *-isCommutativeMonoid =  record
    { isSemigroup = *-isSemigroup
    ; ε∈M         = 1∈R
    ; ε-identityˡ = 1-identityˡ
    ; _∙-comm_    = _*-comm_
    }

record IsIntegralDomain (R : A → Set) (_+_ _*_ : A → A → A)
                        (0# 1# : A) (- : A → A) : Set₁ where
  field
    isRing : IsRing R _+_ _*_ 0# 1# -
    noNonzeroZeroDivisors : {x y : A} → R x → R y
                          → ¬ (x ≈ 0#) → ¬ (y ≈ 0#)
                          → ¬ ((x * y) ≈ 0#)
  open IsRing isRing public
