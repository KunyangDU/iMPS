

function Hamiltonian(Latt::AbstractLattice;t::Number=1,U::Number=0,μ::Number=0,returntree::Bool=false)

    Root = InteractionTreeNode(IdentityOperator(0))

    LocalSpace = Spin2Fermion

    for i in 1:size(Latt)
        addIntr1!(Root,LocalSpace.n,"n",i,-μ)
        addIntr1!(Root,LocalSpace.nd,"nd",i,U)
    end
    
    for pair in neighbor(Latt)
        addIntr2!(Root,LocalSpace.FFdagUp,pair,("F↑","F⁺↑"),t,Spin2Fermion.Z)
        addIntr2!(Root,LocalSpace.FFdagDown,pair,("F↓","F⁺↓"),t,Spin2Fermion.Z)
        addIntr2!(Root,LocalSpace.FdagFUp,pair,("F⁺↑","F↑"),t,Spin2Fermion.Z)
        addIntr2!(Root,LocalSpace.FdagFDown,pair,("F⁺↓","F↓"),t,Spin2Fermion.Z)
    end

    if returntree
        return InteractionTree(Root)
    else
        return AutomataMPO(InteractionTree(Root))  
    end
end

function ParticleNumber(Latt::AbstractLattice,site::Int64)
    Root = InteractionTreeNode(IdentityOperator(0))

    LocalSpace = Spin2Fermion

    addIntr1!(Root,LocalSpace.n,"n",site,1)

    return InteractionTree(Root)
end

function ParticleNumber(Latt::AbstractLattice)
    Root = InteractionTreeNode(IdentityOperator(0))

    LocalSpace = Spin2Fermion

    for i in 1:size(Latt)
        addIntr1!(Root,LocalSpace.n,"n",i,1)
    end

    return InteractionTree(Root)   
end


