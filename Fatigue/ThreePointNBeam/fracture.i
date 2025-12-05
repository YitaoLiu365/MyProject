[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = './mesh.msh'
  []
  construct_side_list_from_node_list = true
  # clone_parent_mesh = true
[]

[Adaptivity]
  initial_marker = init
  initial_steps = 5
  max_h_level = 5
  cycles_per_step = 1
  # marker = combo_marker
  marker = init
  [Markers]
    [init]
      type = BoxMarker
      bottom_left = '-0.2 0 0'
      top_right = '0.2 2 0'
      outside = DO_NOTHING
      inside = REFINE
    []
    # [damage]
    #   type = BoxMarker
    #   bottom_left = '-1.5 0 0'
    #   top_right = '1.5 0.5 0'
    #   outside = DO_NOTHING
    #   inside = REFINE
    # []
    # [combo_marker]
    #   type = ComboMarker
    #   markers = 'init damage'
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
  [crack_surface_density]
    type = CrackSurfaceDensity
    phase_field = d
    output_properties = gamma
    outputs = exodus
  []
[]

[Postprocessors]
  [crack_surface_energy]
    type = ADElementIntegralMaterialProperty
    mat_prop = gamma
    # outputs = csv
    # outputs = exodus
  []
[]

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'
  automatic_scaling = true

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10

  line_search = NONE
[]

[Outputs]
  exodus = true
  # time_step_interval = 4
  print_linear_residuals = false
[]
