using Maxima
using Base.Test

# write your own tests here
@test m"trigsimp(sin(x)^2 + cos(x)^2)" |> mcall |> parse |> eval == 1
