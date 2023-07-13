###########################################################################################################
###########################################################################################################
###########################################################################################################
#                                               BENCHMARKING                                              #
###########################################################################################################
###########################################################################################################
###########################################################################################################
export HyperRaFD, HyperRaFT
###########################################################################################################
struct HyperRaFD
    HyperD::Function
    mode::Symbol
end

function HyperRaFT(HyperD::HyperRaFD, L::Int, n1::arb, ρ1::arb, n2::arb, ρ2::arb)
    user_home_dir = homedir()
    file_time = "cpu_$(HyperD.mode)_time.dat"
    file_val = "cpu_$(HyperD.mode)_val.dat"
    file_tpath = joinpath(user_home_dir, file_time)
    file_vpath = joinpath(user_home_dir, file_val)
    filet = open(file_tpath, "w")
    filev = open(file_vpath, "w")

    total_time = 0.0
    if HyperD.mode == :test
        for s in 0 : L
            time = @elapsed HyperD.HyperD(HyperD.mode, s, n1, ρ1, n2, ρ2)
            val = Float64(NO(HyperD.HyperD(HyperD.mode, s, n1, ρ1, n2, ρ2)))
            println(filet, "$s\t$time\t$total_time")
            total_time += time
        end
    elseif HyperD.mode == :use
        val = Float64(NO(HyperD.HyperD(HyperD.mode, s, n1, ρ1, n2, ρ2)))
        for (index, value) in enumerate(val)
            println(filev, "$index\t$value")
        end
        for s in 0 : L
            time = @elapsed HyperD.HyperD(HyperD.mode, s, n1, ρ1, n2, ρ2)
            println(filet, "$s\t$time\t$total_time")
            total_time += time
        end 
    end
    close(filet)
    close(filev)
end