E = 2.1e5  #MPa
nu = 0.3
K = '${fparse E/3/(1-2*nu)}'
G = '${fparse E/2/(1+nu)}'
lambda = '${fparse E*nu/(1+nu)/(1-2*nu)}'

Gc = 2.7  #N/mm=kN/m
l = 0.04

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
  []
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = './mesh.msh'
  []
  construct_side_list_from_node_list = true
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
  [disp_x]
  []
  [disp_y]
  []
[]

[AuxVariables]
  [d]
  []
  # [alpha_bar_init]
  #   order = CONSTANT
  #   family = MONOMIAL
  # []
  [alpha_bar_avg]
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

[AuxKernels]
  [alpha_bar_avg]
    type = ADMaterialRealAux
    variable = alpha_bar_avg
    property = alpha_bar
  []
[]

[Functions]
  [base_u_t]
    type = PiecewiseLinear
    x = '0 2e-6 4e-6'
    y = '0 -5e-2 0'
  []
  [periodic_u_t]
    type = PeriodicFunction
    base_function = base_u_t
    period_time = 4e-6
  []
  [base_dt]
    # type = PiecewiseLinear
    # x = '0 1e-6 2e-6 4e-6'
    # y = '1e-6 1e-6 2e-6 1e-6'
    type = ADParsedFunction
    expression = 'if(t=2e-6,2e-6,1e-6)'
  []
  [periodic_dt]
    type = PeriodicFunction
    base_function = base_dt
    period_time = 4e-6
  []
[]

[BCs]
  [ydisp]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = load
    function = periodic_u_t
  []
  [right_yfix]
    type = DirichletBC
    variable = disp_y
    boundary = right_fix
    value = 0
  []
  [left_yfix]
    type = DirichletBC
    variable = disp_y
    boundary = left_fix
    value = 0
  []
  [left_xfix]
    type = DirichletBC
    variable = disp_x
    boundary = left_fix
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
    # start_from_zero = true
    # initial = alpha_bar_init
    outputs = exodus
  []
  [fatigue_degradation]
    type = FatigueDegradation
    property_name = f
    history_variable = alpha_bar
    coefficient = 10
    crack_geometric_model = AT2
    outputs = exodus
  []
[]

[Postprocessors]
  [max_d]
    type = NodalExtremeValue
    variable = d
  []
  [max_psie_active]
    type = ADElementExtremeMaterialProperty
    mat_prop = psie_active
    value_type = MAX
    execute_on = ' INITIAL TIMESTEP_END'
  []
[]

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist                 '
  automatic_scaling = true

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8

  # dt = 1e-6
  [TimeStepper]
    type = FunctionDT
    function = periodic_dt
  []
  end_time = 4e-4
  # end_time = 2e-6  #initial output for restart

  fixed_point_max_its = 20
  accept_on_max_fixed_point_iteration = true
  fixed_point_rel_tol = 1e-8
  fixed_point_abs_tol = 1e-10
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
  # file_base = './out/AT2/irreversible'
  file_base = './out/AT2_unload/conditional_new'
  # [out]
  #   type = Checkpoint
  #   time_step_interval = 2
  # []
[]
