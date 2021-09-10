#Janossy Densities: https://arxiv.org/abs/math-ph/0212063
# Formula (6) on p.3

# The key idea is to start with a projection DPP 
# which means the probability space consists of sets of size n
# then we intersect with a specfied set 𝓘Janossy
# so now we have a probality space on the powerset of 𝓘Janossy
# and the result is that this is a DPP 

# Generate a Random Projection DPP
using Combinatorics, Printf, LinearAlgebra
N = 9
n = 4
Y = Matrix(qr(randn(N,n)).Q)

K = Y*Y'
L = zero.(K)
𝓘 =[2,4,6,8] # Restrict to an "I" 

L[𝓘,𝓘] = K[𝓘,𝓘]
L = L/(I-L) # Formula (6) on p.3 

println("====")
println("Janossy = ", 𝓘)
probs=Float64[]
for ℋ ∈ powerset(𝓘)
    println(ℋ,":", [J for J ∈ combinations(1:N,n)  if  J ∩ 𝓘 == ℋ])

    # we sum over all J of size n such that J ∩ (Janossy set) == ℋ
    p = sum( Float64[det(K[J,J]) for J ∈ combinations(1:N,n)  if  J ∩ 𝓘 == ℋ] ) # determinants of size n
    # equivalently we take ℋ and add n-|ℋ| elements that are all in the Janossy set
    # this has the advantage of no rejecting
    #r = sum( Float64[det(K[J,J]) for J ∈ union.([ℋ],combinations( setdiff(1:N,𝓘), n-length(ℋ)))])
    q = det(L[ℋ,ℋ])/det(I+L) # dets of size 1 through n
    q = det(L[ℋ,ℋ])*det(I-K[ℋ,ℋ]) # dets of size 1 through n
    
    # I1 = Diagonal(  1:N .∉ [ℋ])
    # I2 = Diagonal(  1:N .∈ [union(ℋ,setdiff(1:N,𝓘))])
    # M = I1+I2*(1_000_000*K)
    # S1 = union(ℋ,setdiff(1:N,𝓘))
    # s =   det(M[S1,S1]) / 1e6^n
    # M2 = I1+(1_000_000*K) 
    # s = det(I1[S1,S1]+(1_000_000*K[S1,S1])) /1e6^n
    # KK = K[S1,S1] / (I/1e6 +K[S1,S1] )
    # #display(KK^2-KK)
    # u = 1:length(ℋ)
    # display(KK[u,u])
    # display(det(KK[u,u]))
    # display(eigvals(K[S1,S1]))
    #t =  det(I +1_000_000*K[S1,S1] )* det(KK[u,u]  )         /1e6^n

    # display("I1=") #I1 is 0 on ℋ and 1 on setdiff(1:N,𝓘)
    # display(I1)
    # display(Diagonal(I1[S1,S1]))
    
   # display( I1+I2*(1_000_000*K) )
    println(p," ",q) #, " ",r," ",s," ",t)
    push!(probs,p)
end  
println("total probability = ",sum(probs))

