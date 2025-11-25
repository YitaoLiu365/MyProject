E = 2.1e5  #MPa
nu = 0.3
K = '${fparse E/3/(1-2*nu)}'
G = '${fparse E/2/(1+nu)}'
lambda = '${fparse E*nu/(1+nu)/(1-2*nu)}'

Gc = 2.7  #N/mm=kN/m
l = 0.02

[MultiApps]
  [fracture]
    type = TransientMultiApp
    input_files = fracture.i
    cli_args = 'Gc=${Gc};l=${l}'
    execute_on = 'TIMESTEP_END'
  []
[]

[Transfers]
  [from_d]
    type = MultiAppCopyTransfer
    from_multi_app = 'fracture'
    variable = d
    source_variable = d
  []
  [to_fracture]
    type = MultiAppCopyTransfer
    to_multi_app = 'fracture'
    variable = 'psie_active f'
    source_variable = 'psie_active f'
    # variable = 'psie_active'
    # source_variable = 'psie_active'
  []
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

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
  [disp_x]
  []
  [disp_y]
  []
[]

[AuxVariables]
  [d]
  []
  [alpha_bar_init]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [solid_x]
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
  []
  [solid_y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
  []
[]

[Functions]
  [base_u_t]
    type = PiecewiseLinear
    x = '0 2e-5 4e-5'
    y = '0 3e-3 0'
  []
  [periodic_u_t]
    type = PeriodicFunction
    base_function = base_u_t
    period_time = 4e-5
  []
[]

[BCs]
  [xdisp]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = top
    function = periodic_u_t
    # function = 't'
  []
  [yfix]
    type = DirichletBC
    variable = disp_y
    boundary = 'top bottom'
    value = 0
  []
  [xfix]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0
  []
[]

[Materials]
  [bulk]
    type = ADGenericConstantMaterial
    prop_names = 'E K G lambda l Gc'
    prop_values = '${E} ${K} ${G} ${lambda} ${l} ${Gc}'
  []
  [degradation]
    type = PowerDegradationFunction
    property_name = g
    expression = (1-d)^p*(1-eta)+eta
    phase_field = d
    parameter_names = 'p eta '
    parameter_values = '2 1e-6'
  []
  [strain]
    type = ADComputeSmallStrain
  []
  [elasticity]
    type = SmallDeformationIsotropicElasticity
    bulk_modulus = K
    shear_modulus = G
    phase_field = d
    degradation_function = g
    decomposition = SPECTRAL
    output_properties = 'elastic_strain psie_active'
    outputs = exodus
  []
  [stress]
    type = ComputeSmallDeformationStress
    elasticity_model = elasticity
    output_properties = 'stress'
    outputs = exodus
  []
  [g_psie_active]
    type = ADParsedMaterial
    property_name = g_psie_active
    expression = 'g*psie_active'
    coupled_variables = 'd'
    material_property_names = 'g(d) psie_active'
  []
  [hist]
    type = FatigueHistoryVariable
    property_name = alpha_bar
    history_quantity = g_psie_active
    start_from_zero = true
    initial = alpha_bar_init
    outputs = exodus
  []
  [fatigue_degradation]
    type = FatigueDegradation
    property_name = f
    history_variable = alpha_bar
    crack_geometric_model = AT2
    outputs = exodus
  []
[]

[Postprocessors]
  [max_d]
    type = NodalExtremeValue
    variable = d
  []
[]

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist                 '
  automatic_scaling = true

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10

  dt = 1e-5
  # end_time = 32e-6
  end_time = 2e-2

  fixed_point_max_its = 20
  accept_on_max_fixed_point_iteration = true
  fixed_point_rel_tol = 1e-8
  fixed_point_abs_tol = 1e-10
[]

[Outputs]
  exodus = true
  time_step_interval = 4
  print_linear_residuals = false
  file_base = './out/non_invert'
[]
