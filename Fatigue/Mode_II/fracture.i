[Mesh]
  # [gen]
  #   type = GeneratedMeshGenerator
  #   dim = 2
  #   nx = 50
  #   ny = 25
  #   ymax = 0.5
  # []
  # [noncrack]
  #   type = BoundingBoxNodeSetGenerator
  #   input = gen
  #   new_boundary = noncrack
  #   bottom_left = '0.5 0 0'
  #   top_right = '1 0 0'
  # []
  [fmg]
    type = FileMeshGenerator
    file = './mesh.msh'
  []
  construct_side_list_from_node_list = true
[]

[Adaptivity]
  marker = marker_lower
  initial_marker = marker_lower
  initial_steps = 2
  stop_time = 0
  max_h_level = 2
  [Markers]
    [marker_lower]
      type = OrientedBoxMarker
      center = '0.65 -0.25 0'
      length = 0.8
      width = 0.2
      height = 1
      length_direction = '1 -1.5 0'
      width_direction = '1.5 1 0'
      outside = DO_NOTHING
      inside = REFINE
    []
    # [marker_upper]
    #   type = OrientedBoxMarker
    #   center = '0.65 0.25 0'
    #   length = 0.8
    #   width = 0.2
    #   height = 1
    #   length_direction = '1 1.5 0'
    #   width_direction = '1.5 -1 0'
    #   outside = DO_NOTHING
    #   inside = REFINE
    # []
    # [marker]
    #   type = ComboMarker
    #   markers = 'marker_upper marker_lower'
    # []
  []
[]

[Variables]
  [d]
  []
[]

[AuxVariables]
  [bounds_dummy]
  []
  [psie_active]
    order = CONSTANT
    family = MONOMIAL
  []
  [f]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Bounds]
  # [irreversibility]
  #   type = VariableOldValueBounds
  #   variable = bounds_dummy
  #   bounded_variable = d
  #   bound_type = lower
  # []
  [conditional]
    type = ConditionalBoundsAux
    variable = 'bounds_dummy'
    bounded_variable = 'd'
    fixed_bound_value = 0
    threshold_value = 0.95
  []
  [upper]
    type = ConstantBounds
    variable = bounds_dummy
    bounded_variable = d
    bound_type = upper
    bound_value = 1
  []
[]

[Kernels]
  [diff]
    type = ADPFFDiffusion
    variable = d
    fracture_toughness = Gc_f
    # fracture_toughness = Gc
    regularization_length = l
    normalization_constant = c0
  []
  [source]
    type = ADPFFSource
    variable = d
    free_energy = psi
  []
[]

[Materials]
  [fracture_properties]
    type = ADGenericConstantMaterial
    prop_names = 'Gc l'
    prop_values = '${Gc} ${l}'
  []
  [degradation]
    type = PowerDegradationFunction
    property_name = g
    expression = (1-d)^p*(1-eta)+eta
    phase_field = d
    parameter_names = 'p eta '
    parameter_values = '2 1e-6'
  []
  [crack_geometric]
    type = CrackGeometricFunction
    property_name = alpha
    expression = 'd^2'
    phase_field = d
  []
  [psi]
    type = ADDerivativeParsedMaterial
    property_name = psi
    expression = 'alpha*Gc_f/c0/l+g*psie_active'
    coupled_variables = 'd psie_active'
    material_property_names = 'alpha(d) g(d) Gc_f c0 l'
    # expression = 'alpha*Gc/c0/l+g*psie_active'
    # coupled_variables = 'd psie_active'
    # material_property_names = 'alpha(d) g(d) Gc c0 l'
    derivative_order = 1
  []
  # [grad_f]
  #   type = ADCoupledGradientMaterial
  #   gradient_material_name = grad_f
  #   coupled_variable = f
  #   outputs = exodus
  # []
  [Gc_f]
    type = ADParsedMaterial
    property_name = Gc_f
    expression = 'Gc*f'
    material_property_names = 'Gc'
    coupled_variables = 'f'
    outputs = exodus
  []
  # [crack_surface_density]
  #   type = CrackSurfaceDensity
  #   phase_field = d
  #   output_properties = gamma
  #   outputs = exodus
  # []
[]

# [Postprocessors]
#   [crack_surface_energy]
#     type = ADElementIntegralMaterialProperty
#     mat_prop = gamma
#     # outputs = csv
#     # outputs = exodus
#   []
# []

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'
  automatic_scaling = true

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
[]

[Outputs]
  exodus = true
  # time_step_interval = 4
  print_linear_residuals = false
  # file_base = './out_cyclicLoad/l${l}_h_fracture'
  # file_base = './out_cyclicLoad/fracture_old'
[]
