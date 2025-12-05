import os
import gmsh
import sys
import math

gmsh.initialize()
gmsh.model.add("ThreePointBeam")

# # --- Mesh with length=10, point loading ---#
# p1 = gmsh.model.occ.addPoint(5, 0, 0)
# p2 = gmsh.model.occ.addPoint(5, 2, 0)
# p3 = gmsh.model.occ.addPoint(0, 2, 0)
# p4 = gmsh.model.occ.addPoint(-5, 2, 0)
# p5 = gmsh.model.occ.addPoint(-5, 0, 0)
# l1 = gmsh.model.occ.addLine(p1, p2)
# l2 = gmsh.model.occ.addLine(p2, p3)
# l3 = gmsh.model.occ.addLine(p3, p4)
# l4 = gmsh.model.occ.addLine(p4, p5)
# l5 = gmsh.model.occ.addLine(p5, p1)
# loop = gmsh.model.occ.addCurveLoop([l1, l2, l3, l4, l5])
# plane = gmsh.model.occ.addPlaneSurface([loop])
# gmsh.model.occ.synchronize()

# gmsh.model.mesh.setTransfiniteCurve(1,11)
# gmsh.model.mesh.setTransfiniteCurve(2,26)
# gmsh.model.mesh.setTransfiniteCurve(3,26)
# gmsh.model.mesh.setTransfiniteCurve(4,11)
# gmsh.model.mesh.setTransfiniteCurve(5,51)

# gmsh.model.mesh.setTransfiniteSurface(1, "Left", [1,2,4,5])
# gmsh.model.occ.synchronize()

# gmsh.model.addPhysicalGroup(0,[1],-1,"right_fix")
# gmsh.model.addPhysicalGroup(0,[5],-1,"left_fix")
# gmsh.model.addPhysicalGroup(0,[3],-1,"load")
# gmsh.model.addPhysicalGroup(2, [1], -1, "Entire_Surface")

# # --- Mesh with length=12, point loading ---#
# p1 = gmsh.model.occ.addPoint(5, 0, 0)
# p2 = gmsh.model.occ.addPoint(6, 0, 0)
# p3 = gmsh.model.occ.addPoint(6, 2, 0)
# p4 = gmsh.model.occ.addPoint(0, 2, 0)
# p5 = gmsh.model.occ.addPoint(-6, 2, 0)
# p6 = gmsh.model.occ.addPoint(-6, 0, 0)
# p7 = gmsh.model.occ.addPoint(-5, 0, 0)
# l1 = gmsh.model.occ.addLine(p1, p2)
# l2 = gmsh.model.occ.addLine(p2, p3)
# l3 = gmsh.model.occ.addLine(p3, p4)
# l4 = gmsh.model.occ.addLine(p4, p5)
# l5 = gmsh.model.occ.addLine(p5, p6)
# l6 = gmsh.model.occ.addLine(p6, p7)
# l7 = gmsh.model.occ.addLine(p7, p1)
# loop = gmsh.model.occ.addCurveLoop([l1, l2, l3, l4, l5, l6, l7])
# plane = gmsh.model.occ.addPlaneSurface([loop])
# gmsh.model.occ.synchronize()

# gmsh.model.mesh.setTransfiniteCurve(1,6)
# gmsh.model.mesh.setTransfiniteCurve(2,11)
# gmsh.model.mesh.setTransfiniteCurve(3,31)
# gmsh.model.mesh.setTransfiniteCurve(4,31)
# gmsh.model.mesh.setTransfiniteCurve(5,11)
# gmsh.model.mesh.setTransfiniteCurve(6,6)
# gmsh.model.mesh.setTransfiniteCurve(7,51)

# gmsh.model.mesh.setTransfiniteSurface(1, "Left", [2,3,5,6])
# gmsh.model.occ.synchronize()

# gmsh.model.addPhysicalGroup(0,[1],-1,"right_fix")
# gmsh.model.addPhysicalGroup(0,[7],-1,"left_fix")
# gmsh.model.addPhysicalGroup(0,[4],-1,"load")
# gmsh.model.addPhysicalGroup(2, [1], -1, "Entire_Surface")

# # --- Mesh with length=10, line loading ---#
# p1 = gmsh.model.occ.addPoint(5, 0, 0)
# p2 = gmsh.model.occ.addPoint(5, 2, 0)
# p3 = gmsh.model.occ.addPoint(0.2, 2, 0)
# p4 = gmsh.model.occ.addPoint(-0.2, 2, 0)
# p5 = gmsh.model.occ.addPoint(-5, 2, 0)
# p6 = gmsh.model.occ.addPoint(-5, 0, 0)
# l1 = gmsh.model.occ.addLine(p1, p2)
# l2 = gmsh.model.occ.addLine(p2, p3)
# l3 = gmsh.model.occ.addLine(p3, p4)
# l4 = gmsh.model.occ.addLine(p4, p5)
# l5 = gmsh.model.occ.addLine(p5, p6)
# l6 = gmsh.model.occ.addLine(p6, p1)
# loop = gmsh.model.occ.addCurveLoop([l1, l2, l3, l4, l5, l6])
# plane = gmsh.model.occ.addPlaneSurface([loop])
# gmsh.model.occ.synchronize()

# gmsh.model.mesh.setTransfiniteCurve(1,11)
# gmsh.model.mesh.setTransfiniteCurve(2,25)
# gmsh.model.mesh.setTransfiniteCurve(3,3)
# gmsh.model.mesh.setTransfiniteCurve(4,25)
# gmsh.model.mesh.setTransfiniteCurve(5,11)
# gmsh.model.mesh.setTransfiniteCurve(6,51)

# gmsh.model.mesh.setTransfiniteSurface(1, "Left", [1,2,5,6])
# gmsh.model.occ.synchronize()

# gmsh.model.addPhysicalGroup(0,[1],-1,"right_fix")
# gmsh.model.addPhysicalGroup(0,[6],-1,"left_fix")
# gmsh.model.addPhysicalGroup(1,[3],-1,"load")
# gmsh.model.addPhysicalGroup(2, [1], -1, "Entire_Surface")

# --- Mesh with length=12, line loading ---#
p1 = gmsh.model.occ.addPoint(5, 0, 0)
p2 = gmsh.model.occ.addPoint(6, 0, 0)
p3 = gmsh.model.occ.addPoint(6, 2, 0)
p4 = gmsh.model.occ.addPoint(0.2, 2, 0)
p5 = gmsh.model.occ.addPoint(-0.2, 2, 0)
p6 = gmsh.model.occ.addPoint(-6, 2, 0)
p7 = gmsh.model.occ.addPoint(-6, 0, 0)
p8 = gmsh.model.occ.addPoint(-5, 0, 0)
l1 = gmsh.model.occ.addLine(p1, p2)
l2 = gmsh.model.occ.addLine(p2, p3)
l3 = gmsh.model.occ.addLine(p3, p4)
l4 = gmsh.model.occ.addLine(p4, p5)
l5 = gmsh.model.occ.addLine(p5, p6)
l6 = gmsh.model.occ.addLine(p6, p7)
l7 = gmsh.model.occ.addLine(p7, p8)
l8 = gmsh.model.occ.addLine(p8, p1)
loop = gmsh.model.occ.addCurveLoop([l1, l2, l3, l4, l5, l6, l7, l8])
plane = gmsh.model.occ.addPlaneSurface([loop])
gmsh.model.occ.synchronize()

gmsh.model.mesh.setTransfiniteCurve(1,6)
gmsh.model.mesh.setTransfiniteCurve(2,11)
gmsh.model.mesh.setTransfiniteCurve(3,30)
gmsh.model.mesh.setTransfiniteCurve(4,3)
gmsh.model.mesh.setTransfiniteCurve(5,30)
gmsh.model.mesh.setTransfiniteCurve(6,11)
gmsh.model.mesh.setTransfiniteCurve(7,6)
gmsh.model.mesh.setTransfiniteCurve(8,51)

gmsh.model.mesh.setTransfiniteSurface(1, "Left", [2,3,6,7])
gmsh.model.occ.synchronize()

gmsh.model.addPhysicalGroup(0,[1],-1,"right_fix")
gmsh.model.addPhysicalGroup(0,[8],-1,"left_fix")
gmsh.model.addPhysicalGroup(1,[4],-1,"load")
gmsh.model.addPhysicalGroup(2, [1], -1, "Entire_Surface")

gmsh.model.mesh.setRecombine(2, 1)
gmsh.model.mesh.generate(2)

gmsh.write(
    "./mesh.msh"
)

if "-nopopup" not in sys.argv:
    gmsh.fltk.run()

gmsh.finalize()
