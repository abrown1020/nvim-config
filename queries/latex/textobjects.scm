
;; Inline math: \( ... \) or $...$
((inline_formula) @math.inner @math.outer)

;; Displayed math: \[ ... \] or \begin{equation}
((displayed_equation) @math.inner @math.outer)

;; Optional: catch more complex environments like align, gather, etc.
((math_environment) @math.inner @math.outer)
