import os
import gmsh
import sys
import math

gmsh.initialize()
gmsh.model.add("Mode_I")

p1 = gmsh.model.occ.addPoint(0.5, 0, 0)
p2 = gmsh.model.occ.addPoint(0, 0.0005, 0)
p3 = gmsh.model.occ.addPoint(0, 0.5, 0)
p4 = gmsh.model.occ.addPoint(1, 0.5, 0)
p5 = gmsh.model.occ.addPoint(1, 0, 0)
p6 = gmsh.model.occ.addPoint(1, -0.5, 0)
p7 = gmsh.model.occ.addPoint(0, -0.5, 0)
p8 = gmsh.model.occ.addPoint(0, -0.0005, 0)
l1 = gmsh.model.occ.addLine(p1, p2)
l2 = gmsh.model.occ.addLine(p2, p3)
l3 = gmsh.model.occ.addLine(p3, p4)
l4 = gmsh.model.occ.addLine(p4, p5)
l5 = gmsh.model.occ.addLine(p5, p6)
l6 = gmsh.model.occ.addLine(p6, p7)
l7 = gmsh.model.occ.addLine(p7, p8)
l8 = gmsh.model.occ.addLine(p8, p1)
l9 = gmsh.model.occ.addLine(p1, p5)
loop = gmsh.model.occ.addCurveLoop([l1, l2, l3, l4, l5, l6, l7, l8])
plane = gmsh.model.occ.addPlaneSurface([loop])
gmsh.model.occ.fragment([(2, plane)], [(1, l9)])
gmsh.model.occ.synchronize()

gmsh.model.mesh.setTransfiniteCurve(13,26)
gmsh.model.mesh.setTransfiniteCurve(12,26)
gmsh.model.mesh.setTransfiniteCurve(11,51)
gmsh.model.mesh.setTransfiniteCurve(10,26)
gmsh.model.mesh.setTransfiniteCurve(17,26)
gmsh.model.mesh.setTransfiniteCurve(16,51)
gmsh.model.mesh.setTransfiniteCurve(15,26)
gmsh.model.mesh.setTransfiniteCurve(14,26)
gmsh.model.mesh.setTransfiniteCurve(9,26)

gmsh.model.mesh.setTransfiniteSurface(1, "Left", [4,3,1,2])
gmsh.model.mesh.setTransfiniteSurface(2, "Left", [6,7,8,2])
gmsh.model.occ.synchronize()

gmsh.model.addPhysicalGroup(0,[7],-1,"left_bottom")
gmsh.model.addPhysicalGroup(1,[11],-1,"top")
gmsh.model.addPhysicalGroup(1,[16],-1,"bottom")
gmsh.model.addPhysicalGroup(2, [1,2], -1, "Entire_Surface")

gmsh.model.mesh.setRecombine(2, 1)
gmsh.model.mesh.setRecombine(2, 2)
gmsh.model.mesh.generate(2)

gmsh.write(
    "./mesh.msh"
)

if "-nopopup" not in sys.argv:
    gmsh.fltk.run()

gmsh.finalize()
