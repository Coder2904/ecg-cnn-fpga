# =============================================================================
# run_all_tb.tcl
# Master Vivado simulation script — runs ALL testbenches sequentially
# Usage: vivado -mode batch -source run_all_tb.tcl
# =============================================================================

set part "xc7z020clg400-1"
set rtl_files {
    ./rtl_v2/ecg_pipeline_top.v
    ./ecg_top_from_doc.v
    ./conv1d_engine_from_doc.v
    ./dense_engine_from_doc.v
    ./secure_alert_from_doc.v
    ./config_reg_block_from_doc.v
    ./maxpool1d_unit_from_doc.v
    ./sigmoid_classifier_from_doc.v
    ./input_buffer_from_doc.v
}

set tb_list {
    { input_buffer_tb       ./tb/input_buffer_tb.v        }
    { conv1d_engine_tb      ./tb/conv1d_engine_tb.v       }
    { maxpool1d_unit_tb     ./tb/maxpool1d_unit_tb.v      }
    { dense_engine_tb       ./tb/dense_engine_tb.v        }
    { sigmoid_classifier_tb ./tb/sigmoid_classifier_tb.v  }
    { secure_alert_tb       ./tb/secure_alert_tb.v        }
    { config_reg_block_tb   ./tb/config_reg_block_tb.v    }
    { ecg_top_tb            ./tb/ecg_top_tb.v             }
    { ecg_pipeline_top_tb   ./tb/ecg_pipeline_top_tb.v   }
}

proc run_tb {tb_name tb_file all_rtl} {
    puts "\n================================================================"
    puts " RUNNING: $tb_name"
    puts "================================================================"

    set proj_name "sim_${tb_name}"
    create_project $proj_name ./vivado_sims/$proj_name -part xc7z020clg400-1 -force

    # Add all RTL sources
    foreach f $all_rtl {
        if {[file exists $f]} {
            add_files -norecurse $f
        }
    }

    # Add testbench
    add_files -fileset sim_1 -norecurse $tb_file

    # Add hex files
    set hex_files [glob -nocomplain *.hex]
    if {[llength $hex_files] > 0} {
        add_files -norecurse $hex_files
    }

    # Include dirs
    set_property include_dirs {./rtl ./rtl_v2} [current_fileset]
    set_property include_dirs {./rtl ./rtl_v2} [get_filesets sim_1]

    # Set tops
    set_property top $tb_name [get_filesets sim_1]

    # Simulation settings
    set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

    # Run
    launch_simulation -simset sim_1 -mode behavioral
    run all
    close_sim

    puts " DONE: $tb_name"
}

# Run all testbenches
set pass_count 0
set fail_count 0

foreach tb_entry $tb_list {
    set tb_name [lindex $tb_entry 0]
    set tb_file [lindex $tb_entry 1]

    if {[file exists $tb_file]} {
        if {[catch {run_tb $tb_name $tb_file $rtl_files} err]} {
            puts "ERROR in $tb_name: $err"
            incr fail_count
        } else {
            incr pass_count
        }
    } else {
        puts "SKIP: $tb_file not found"
    }
}

puts "\n================================================================"
puts " ALL SIMULATIONS COMPLETE"
puts " Passed: $pass_count  Failed: $fail_count"
puts "================================================================"
