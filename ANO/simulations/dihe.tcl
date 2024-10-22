proc signed_angle { a b c } {
  set amag [veclength $a]
  set bmag [veclength $b]
  set dotprod [vecdot $a $b]
  
  set crossp [veccross $a $b]
  set sign [vecdot $crossp $c]
  if { $sign < 0 } { 
    set sign -1 
  } else { 
    set sign 1
  }
  return [expr $sign * 57.2958 * acos($dotprod / ($amag * $bmag))]
}
    
proc dihedral { a1 a2 a3 a4 } {
  if {[llength $a1] != 3 || [llength $a2] != 3 || [llength $a3] != 3 || [llength $a4] != 3} {
    return 0
  } 
 
  set r1 [vecsub $a1 $a2]
  set r2 [vecsub $a3 $a2]
  set r3 [vecscale $r2 -1]
  set r4 [vecsub $a4 $a3]

  set n1 [veccross $r1 $r2]
  set n2 [veccross $r3 $r4]
  
  return [signed_angle $n1 $n2 $r2]
}

set mol [mol load psf [ID]_wbi.psf dcd [ID]_wbi.dcd]

set outfile [open "dihe.dat" w];
set nf [molinfo $mol get numframes]  

set nucbase "nucleic and not hydrogen and not (name P or name O1P or name O2P or name O5' or name C5' or name C4' or name O4' or name C1' or name C2' or name O2' or name C3' or name O3')"

# calculation loop  
for { set i 1 } { $i <= $nf } { incr i 1} {  

    # select four (center of mass) points that define torsion angle
    set sel [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set com1 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com2 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID3]" frame $i]
    set com3 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID4]" frame $i]
    set com4 [measure center $sel]
    set dihe1 [dihedral $com1 $com2 $com3 $com4]


    set sel [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set com1 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com2 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID3]" frame $i]
    set com3 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID4]" frame $i]
    set com4 [measure center $sel]
    set dihe2 [dihedral $com1 $com2 $com3 $com4]


    set sel [atomselect $mol "$nucbase and resid [RESID1]" frame $i]
    set com1 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID2]" frame $i]
    set com2 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID3]" frame $i]
    set com3 [measure center $sel]
    set sel [atomselect $mol "$nucbase and resid [RESID4]" frame $i]
    set com4 [measure center $sel]
    set dihe3 [dihedral $com1 $com2 $com3 $com4]

puts $outfile "$i $dihe1 $dihe2 $dihe3"
}
#$outfile 

exit


