clear -all
analyze -sv09 {coop.sv}
elaborate -bbox_mul 1024 -top wrap
clock clk
reset rst

# Don't change anything above this line.

# Put the abstractions for the proof of <embedded>::wrap.valid_id here.
#Failed attempts :)
#stopat data_in
#abstract data_in
#abstract -counter len_in
#abstract -counter calculator_i.cnt
#abstract -counter calculator_i.len
#abstract -counter data_in
#stopat  generator_i.len
#abstract -counter generator_i.id_cnt# WRONG KIND :///////////////
stopat generator_i.id_cnt
abstract -init_value generator_i.cnt
abstract -init_value generator_i.len
abstract -init_value calculator_i.cnt
abstract -init_value calculator_i.len
abstract -init_value calculator_i.id
# Don't change anything below this line.

check_return {prove -property {<embedded>::wrap.valid_id} -time_limit 300s -engine N -orch off} proven
