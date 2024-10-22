set mol [mol load psf [ID]_wbi.psf dcd [ID]_wbi.dcd]

set outfile [open "dist.dat" w];
set nf [molinfo $mol get numframes]  

set nucbase "nucleic and not hydrogen and not (name P or name O1P or name O2P or name O5' or name C5' or name C4' or name O4' or name C1' or name C2' or name O2' or name C3' or name O3')"

# calculation loop  
for { set i 1 } { $i <= $nf } { incr i 1 } {  

    # base to base distances
    set sel1 [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set sel2 [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com1 [measure center $sel1]
    set com2 [measure center $sel2]
    set comd1 [veclength [vecsub $com1 $com2]]

    set sel1 [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set sel2 [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com1 [measure center $sel1]
    set com2 [measure center $sel2]
    set comd2 [veclength [vecsub $com1 $com2]]

    set sel1 [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set sel2 [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com1 [measure center $sel1]
    set com2 [measure center $sel2]
    set comd3 [veclength [vecsub $com1 $com2]]
 
    set sel1 [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set sel2 [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com1 [measure center $sel1]
    set com2 [measure center $sel2]
    set comd4 [veclength [vecsub $com1 $com2]]

    set sel1 [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set sel2 [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com1 [measure center $sel1]
    set com2 [measure center $sel2]
    set comd5 [veclength [vecsub $com1 $com2]]

    set sel1 [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set sel2 [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com1 [measure center $sel1]
    set com2 [measure center $sel2]
    set comd6 [veclength [vecsub $com1 $com2]]

    
puts $outfile "$i $comd1 $comd2 $comd3 $comd4 $comd5 $comd6"
}
#$outfile 

exit

