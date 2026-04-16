function results = sweep_pid_gains_to_excel(mode_name, output_path, cases)
% Sweep multiple PID gain sets and export the resulting metrics to Excel.
%
% Usage:
%   results = sweep_pid_gains_to_excel
%   results = sweep_pid_gains_to_excel('no_render')
%   results = sweep_pid_gains_to_excel('no_render', 'D:\MATLAB\Vega Simulations\out\logs\pid_gain_sweep.xlsx')
%
% The workbook contains:
%   - Resume          : one row per simulated gain set
%   - Definitions     : gain values and filter settings for each case
%   - Series_Angles   : time histories of angles, references and moments

    if nargin < 1 || isempty(mode_name)
        mode_name = 'no_render';
    end

    paths = build_sweep_paths();
    ensure_sweep_dirs(paths);

    if nargin < 2 || isempty(output_path)
        output_path = fullfile(paths.logs_dir, 'pid_gain_sweep.xlsx');
    end

    if nargin < 3 || isempty(cases)
        cases = default_sweep_cases();
    end

    close all;
    clc;

    num_cases = numel(cases);
    summary_rows = cell(num_cases, 1);
    def_rows = cell(num_cases, 1);
    series_tables = cell(num_cases, 1);

    for i = 1:num_cases
        case_cfg = cases(i);
        override = build_override_from_case(case_cfg);
        [data, metrics] = modele_vega_PID_ok(mode_name, override);
        pitch = compute_pitch_metrics_local(data);
        pidm = compute_pid_metrics_local(data);

        summary_rows{i} = build_summary_struct(case_cfg, metrics, pitch, pidm);
        def_rows{i} = build_definition_struct(case_cfg);
        series_tables{i} = build_case_series_table(case_cfg.name, data);
    end

    results.summary = struct2table([summary_rows{:}]');
    results.definitions = struct2table([def_rows{:}]');
    results.series = vertcat(series_tables{:});

    writetable(results.summary, output_path, 'Sheet', 'Resume');
    writetable(results.definitions, output_path, 'Sheet', 'Definitions');
    writetable(results.series, output_path, 'Sheet', 'Series_Angles');

    csv_path = fullfile(paths.logs_dir, 'pid_gain_sweep_summary.csv');
    writetable(results.summary, csv_path);

    fprintf('\n===== SWEEP PID GAINS =====\n');
    fprintf('Classeur Excel : %s\n', output_path);
    fprintf('Resume CSV     : %s\n', csv_path);
    fprintf('Nombre de cas  : %d\n', num_cases);
end

function paths = build_sweep_paths()
    base_dir = fileparts(mfilename('fullpath'));
    project_dir = fileparts(fileparts(base_dir));
    paths.logs_dir = fullfile(project_dir, 'out', 'logs');
end

function ensure_sweep_dirs(paths)
    if ~exist(paths.logs_dir, 'dir')
        mkdir(paths.logs_dir);
    end
end

function cases = default_sweep_cases()
    cases = struct( ...
        'name', { ...
            'sans_pid_reference', ...
            'reglage_actuel', ...
            'theta_plus_agressif', ...
            'theta_plus_amorti', ...
            'theta_plus_filtre', ...
            'gains_moderes_uniformes'}, ...
        'pid_enabled', { ...
            false, true, true, true, true, true}, ...
        'phi', { ...
            struct('kp', NaN,   'ki', NaN,   'kd', NaN), ...
            struct('kp', 6.4e5, 'ki', 2.4e4, 'kd', 2.2e5), ...
            struct('kp', 6.4e5, 'ki', 2.4e4, 'kd', 2.2e5), ...
            struct('kp', 6.4e5, 'ki', 2.4e4, 'kd', 2.2e5), ...
            struct('kp', 6.4e5, 'ki', 2.4e4, 'kd', 2.2e5), ...
            struct('kp', 5.8e5, 'ki', 2.0e4, 'kd', 1.8e5)}, ...
        'theta', { ...
            struct('kp', NaN,   'ki', NaN,   'kd', NaN), ...
            struct('kp', 2.2e6, 'ki', 6.0e4, 'kd', 2.2e5), ...
            struct('kp', 2.5e6, 'ki', 7.0e4, 'kd', 1.8e5), ...
            struct('kp', 1.9e6, 'ki', 5.0e4, 'kd', 2.8e5), ...
            struct('kp', 2.2e6, 'ki', 6.0e4, 'kd', 2.2e5), ...
            struct('kp', 1.6e6, 'ki', 4.0e4, 'kd', 1.6e5)}, ...
        'psi', { ...
            struct('kp', NaN,   'ki', NaN,   'kd', NaN), ...
            struct('kp', 5.2e5, 'ki', 1.8e4, 'kd', 2.0e5), ...
            struct('kp', 5.2e5, 'ki', 1.8e4, 'kd', 2.0e5), ...
            struct('kp', 5.2e5, 'ki', 1.8e4, 'kd', 2.0e5), ...
            struct('kp', 5.2e5, 'ki', 1.8e4, 'kd', 2.0e5), ...
            struct('kp', 4.6e5, 'ki', 1.4e4, 'kd', 1.7e5)}, ...
        'pid_ref_filter_tau', { ...
            1.0, 1.0, 0.9, 1.1, 1.3, 1.0}, ...
        'pid_derivative_filter_tau', { ...
            0.20, 0.20, 0.16, 0.24, 0.28, 0.22});
end

function override = build_override_from_case(case_cfg)
    override = struct('pid_enabled', case_cfg.pid_enabled);
    if case_cfg.pid_enabled
        override.pid_phi = case_cfg.phi;
        override.pid_theta = case_cfg.theta;
        override.pid_psi = case_cfg.psi;
        override.pid_ref_filter_tau = case_cfg.pid_ref_filter_tau;
        override.pid_derivative_filter_tau = case_cfg.pid_derivative_filter_tau;
    end
end

function s = build_summary_struct(case_cfg, metrics, pitch, pidm)
    s = struct();
    s.cas = string(case_cfg.name);
    s.pid_active = case_cfg.pid_enabled;
    s.kp_phi = case_cfg.phi.kp;
    s.ki_phi = case_cfg.phi.ki;
    s.kd_phi = case_cfg.phi.kd;
    s.kp_theta = case_cfg.theta.kp;
    s.ki_theta = case_cfg.theta.ki;
    s.kd_theta = case_cfg.theta.kd;
    s.kp_psi = case_cfg.psi.kp;
    s.ki_psi = case_cfg.psi.ki;
    s.kd_psi = case_cfg.psi.kd;
    s.ref_filter_tau_s = case_cfg.pid_ref_filter_tau;
    s.derivative_filter_tau_s = case_cfg.pid_derivative_filter_tau;
    s.flight_time_s = metrics.flight_time;
    s.range_xy_m = metrics.range_xy;
    s.max_altitude_m = metrics.max_altitude;
    s.max_speed_mps = metrics.max_speed;
    s.satellite_release_time_s = metrics.satellite_release_time;
    s.final_phi_deg = metrics.final_phi_deg;
    s.final_theta_deg = metrics.final_theta_deg;
    s.final_psi_deg = metrics.final_psi_deg;
    s.max_abs_phi_deg = metrics.max_abs_phi_deg;
    s.max_abs_theta_deg = metrics.max_abs_theta_deg;
    s.max_abs_psi_deg = metrics.max_abs_psi_deg;
    s.theta_rise_time_s = pitch.rise_time_s;
    s.theta_overshoot_pct = pitch.overshoot_pct;
    s.theta_settling_time_s = pitch.settling_time_s;
    s.theta_static_error_deg = pitch.static_error_deg;
    s.theta_rms_error_deg = pitch.rms_error_deg;
    s.theta_command_effort_rms_nm = pitch.command_effort_rms;
    s.rms_phi_deg = pidm.rms_phi_deg;
    s.rms_theta_deg = pidm.rms_theta_deg;
    s.rms_psi_deg = pidm.rms_psi_deg;
    s.max_Mphi_nm = pidm.max_Mphi;
    s.max_Mtheta_nm = pidm.max_Mtheta;
    s.max_Mpsi_nm = pidm.max_Mpsi;
end

function s = build_definition_struct(case_cfg)
    s = struct();
    s.cas = string(case_cfg.name);
    s.pid_active = case_cfg.pid_enabled;
    s.kp_phi = case_cfg.phi.kp;
    s.ki_phi = case_cfg.phi.ki;
    s.kd_phi = case_cfg.phi.kd;
    s.kp_theta = case_cfg.theta.kp;
    s.ki_theta = case_cfg.theta.ki;
    s.kd_theta = case_cfg.theta.kd;
    s.kp_psi = case_cfg.psi.kp;
    s.ki_psi = case_cfg.psi.ki;
    s.kd_psi = case_cfg.psi.kd;
    s.ref_filter_tau_s = case_cfg.pid_ref_filter_tau;
    s.derivative_filter_tau_s = case_cfg.pid_derivative_filter_tau;
end

function T = build_case_series_table(case_name, data)
    n = numel(data.t);
    speed = sqrt(data.vx(:).^2 + data.vy(:).^2 + data.vz(:).^2);
    if isfield(data, 'control_active')
        control_active = data.control_active(:);
    else
        control_active = false(n, 1);
    end
    if isfield(data, 'guidance_active')
        guidance_active = data.guidance_active(:);
    else
        guidance_active = false(n, 1);
    end

    T = table( ...
        repmat(string(case_name), n, 1), data.t(:), ...
        rad2deg(data.phi(:)), rad2deg(data.theta(:)), rad2deg(data.psi(:)), ...
        rad2deg(data.phi_ref(:)), rad2deg(data.theta_ref(:)), rad2deg(data.psi_ref(:)), ...
        data.x(:), data.y(:), data.z(:), speed, data.Tcmd(:), data.mass(:), ...
        guidance_active, control_active, ...
        data.pid_m_phi(:), data.pid_m_theta(:), data.pid_m_psi(:), ...
        'VariableNames', { ...
            'cas', 'time_s', ...
            'phi_deg', 'theta_deg', 'psi_deg', ...
            'phi_ref_deg', 'theta_ref_deg', 'psi_ref_deg', ...
            'x_m', 'y_m', 'z_m', 'speed_mps', 'thrust_n', 'mass_kg', ...
            'guidance_active', 'control_active', ...
            'moment_phi_nm', 'moment_theta_nm', 'moment_psi_nm'});
end

function pitch = compute_pitch_metrics_local(data)
    idx = false(size(data.t));
    if isfield(data, 'guidance_active')
        idx = data.guidance_active;
    end
    t = data.t(idx);
    ref = rad2deg(data.theta_ref(idx));
    theta = rad2deg(data.theta(idx));
    effort = data.pid_m_theta(idx);

    pitch.rise_time_s = NaN;
    pitch.overshoot_pct = NaN;
    pitch.settling_time_s = NaN;
    pitch.static_error_deg = NaN;
    pitch.rms_error_deg = NaN;
    pitch.command_effort_rms = NaN;

    if isempty(t)
        return;
    end

    target = ref(end);
    initial = theta(1);
    delta = target - initial;

    pitch.static_error_deg = target - theta(end);
    pitch.rms_error_deg = sqrt(mean((ref - theta) .^ 2));
    pitch.command_effort_rms = sqrt(mean(effort .^ 2));

    if abs(delta) < 1e-9
        pitch.overshoot_pct = 0;
        pitch.settling_time_s = 0;
        pitch.rise_time_s = 0;
        return;
    end

    lower = initial + 0.1 * delta;
    upper = initial + 0.9 * delta;
    i10 = find_crossing_local(theta, lower, delta);
    i90 = find_crossing_local(theta, upper, delta);
    if ~isempty(i10) && ~isempty(i90) && i90 >= i10
        pitch.rise_time_s = t(i90) - t(i10);
    end

    if delta > 0
        pitch.overshoot_pct = max(0, (max(theta) - target) / abs(delta) * 100);
    else
        pitch.overshoot_pct = max(0, (target - min(theta)) / abs(delta) * 100);
    end

    tol = max(0.05 * abs(delta), 0.5);
    last_outside = find(abs(theta - target) > tol, 1, 'last');
    if isempty(last_outside)
        pitch.settling_time_s = 0;
    elseif last_outside < numel(t)
        pitch.settling_time_s = t(last_outside + 1) - t(1);
    end
end

function idx = find_crossing_local(y, threshold, delta)
    if delta > 0
        idx = find(y >= threshold, 1, 'first');
    else
        idx = find(y <= threshold, 1, 'first');
    end
end

function pidm = compute_pid_metrics_local(data)
    pidm = struct( ...
        'rms_phi_deg', NaN, ...
        'rms_theta_deg', NaN, ...
        'rms_psi_deg', NaN, ...
        'max_Mphi', NaN, ...
        'max_Mtheta', NaN, ...
        'max_Mpsi', NaN);

    if ~isfield(data, 'control_active')
        return;
    end

    idx = find(data.control_active);
    if isempty(idx)
        return;
    end

    ephi_deg = rad2deg(data.phi_ref(idx) - data.phi(idx));
    etheta_deg = rad2deg(data.theta_ref(idx) - data.theta(idx));
    epsi_deg = rad2deg(arrayfun(@wrap_to_pi_local_local, data.psi_ref(idx) - data.psi(idx)));

    pidm.rms_phi_deg = sqrt(mean(ephi_deg .^ 2));
    pidm.rms_theta_deg = sqrt(mean(etheta_deg .^ 2));
    pidm.rms_psi_deg = sqrt(mean(epsi_deg .^ 2));
    pidm.max_Mphi = max(abs(data.pid_m_phi(idx)));
    pidm.max_Mtheta = max(abs(data.pid_m_theta(idx)));
    pidm.max_Mpsi = max(abs(data.pid_m_psi(idx)));
end

function angle = wrap_to_pi_local_local(angle)
    angle = mod(angle + pi, 2 * pi) - pi;
end
