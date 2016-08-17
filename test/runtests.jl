using Maxima
using Base.Test

# write your own tests here
@test 1 == 2

# Text that incorrect expr "1+" does not hang
@test string(mcall(m"1+")) == "incorrectsyntax:Prematureterminationofinputat;.1+;^"

