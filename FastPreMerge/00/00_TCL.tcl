OPENFILE {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00OutMan.cnt}
MERGEEVT {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00Merge.dat}
FILTER_EX LOWPASS ZEROPHASESHIFT x x 30 24 x x x N FIR { ALL } {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-f.cnt}
OPENFILE {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-f.cnt}
LDR {H:OPENFILE {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-l.cnt}
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 3,5,7
EPOCH_EX PORT_INTERNAL "" N -200 800 N Y Y N N SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-e.eeg}
DELETESORT SORT44
OPENFILE {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-e.eeg}
BASECOR_EX PRESTIMINTERVAL x x { ALL } {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-b.eeg} 
OPENFILE {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-b.eeg}
ARTREJ_EX REJCRITERIA Y x x Y -80 80 Y Y { ALL } 
SAVEAS {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-ar.eeg}
OPENFILE {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-ar.eeg}
CLOSEFILE {08-b.eeg}
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 3
SORT44 -CorrectEnabled T
SORT44 -CorrectCriteria CORRECT
AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-avg(3-201).avg}
DELETESORT SORT44
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 3
SORT44 -CorrectEnabled T
SORT44 -CorrectCriteria INCORRECT
AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-avg(3-202).avg}
DELETESORT SORT44
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 5
SORT44 -CorrectEnabled T
SORT44 -CorrectCriteria CORRECT
AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-avg(5-201).avg}
DELETESORT SORT44
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 5
SORT44 -CorrectEnabled T
SORT44 -CorrectCriteria INCORRECT
AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-avg(5-202).avg}
DELETESORT SORT44
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 7
SORT44 -CorrectEnabled T
SORT44 -CorrectCriteria CORRECT
AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-avg(7-201).avg}
DELETESORT SORT44
CREATESORT SORT44
SORT44 -TypeEnabled T
SORT44 -TypeCriteria 7
SORT44 -CorrectEnabled T
SORT44 -CorrectCriteria INCORRECT
AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {/Users/SunCH/MATLAB/schEXPs/FastPreMerge\00\00-avg(7-202).avg}
DELETESORT SORT44
