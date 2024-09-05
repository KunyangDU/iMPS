function Lanczos(A::AbstractMatrix, k::Int)
    n = size(A, 1)
    Q = zeros(n, k)
    α = zeros(k)
    β = zeros(k-1)
    
    q1 = rand(n)
    q1 /= norm(q1)
    Q[:, 1] = q1
    
    for j = 1:k
        if j == 1
            w = A * Q[:, j]
        else
            w = A * Q[:, j] - β[j-1] * Q[:, j-1]
        end
        
        α[j] = dot(Q[:, j], w)
        w -= α[j] * Q[:, j]
        
        if j < k
            β[j] = norm(w)
            if β[j] ≈ 0
                ns = nullspace(Q[:,1:j])
                Q[:, j+1] = ns * randn(size(ns, 2))
            else
                Q[:, j+1] = w / β[j]
            end
        end
    end
    
    T = diagm(0 => α, -1 => β, 1 => β)
    return T, Q
end

function groundEig(A::AbstractMatrix, k::Int)
    T, Q = Lanczos(A, k)
    λ, v = eigen(T)
    return argmin(λ) |> x -> (λ[x], Q * v[:, x])
end

function Lanczos(M::AbstractTensorMap,level::Int64)
    Mdm = domain(M)
    Q = Vector{TensorMap}(undef, level)
    α = zeros(ComplexF64,level)
    β = zeros(ComplexF64,level-1)

    q1 = Tensor(rand, ComplexF64, ⊗([dm for dm in Mdm]...))
    q1 /= norm(q1)
    Q[1] = q1

    for j = 1:level
        if j == 1
            w = M * Q[j]
        else
            w = M * Q[j] - β[j-1] * Q[j-1]
        end

        
        α[j] = (Q[j]'*w)[1]
        w -= α[j] * Q[j]
        
        if j < level
            β[j] = norm(w)
            if β[j] ≈ 0
                @error "flow interrupted"
            else
                Q[j+1] = w / β[j]
            end
        end
    end
    
    T = diagm(0 => α, -1 => β, 1 => β)
    return T, Q
    
end

function groundEig(M::AbstractTensorMap, level::Int)
    T, Q = Lanczos(M, level)
    λ, v = eigen(T)
    Eg,Ev = argmin(real.(λ)) |> x -> (real.(λ)[x], sum(Q .* v[:, x]))
    return Eg, Ev / norm(Ev)
end

