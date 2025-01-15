= PLL:
#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  [Negation?], [Positron?],
  $(Gamma tack.r t : A space space Delta tack.r u : B) / (Gamma, Delta )$,
  $(Gamma, chi : A, y : B tack.r c)/(Gamma, z : A xor B tack.r text("let")(x,y) = z; c)$,
  
  $(Gamma tack.r t: A_1)/(Gamma tack.r text("inj")_1t : A_1 xor A_2)$,
  $(Gamma, chi : A_1 tack.r c_1)/(Gamma, z : A_1 xor A_2 tack.r text("case") z text("of") 
  text("inj"_1 chi |-> c_1))$,
  
  $(Gamma, alpha tack.r : A)/(Gamma tack.r angle.l A,t angle.r: exists alpha. A)$,
  $(Gamma, alpha, chi : A tack.r c)/(Gamma, z : exists alpha . A tack.r text("let") angle.l alpha, chi angle.r = z; c)$,
  
  $(Gamma, chi : Alpha tack.r c)/(Gamma tack.r lambda x . c : not A)$,
  $(Gamma tack.r t : A)/(Gamma, z: not A tack.r text("call") z (t))$,
)