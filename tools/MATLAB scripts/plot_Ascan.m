% plot_Ascan.m
% Script to save and plot EM fields from a gprMax A-scan
%
% Craig Warren

clear all, clc

[filename, pathname] = uigetfile('*.out', 'Select gprMax A-scan output file to plot');
fullfilename = strcat(pathname, filename);

if filename ~= 0
    header.title = h5readatt(fullfilename, '/', 'Title');
    header.iterations = double(h5readatt(fullfilename,'/', 'Iterations'));
    tmp = h5readatt(fullfilename, '/', 'dx, dy, dz');
    header.dx = tmp(1);
    header.dy = tmp(2);
    header.dz = tmp(3);
    header.dt = h5readatt(fullfilename, '/', 'dt');
    header.nsrc = h5readatt(fullfilename, '/', 'nsrc');
    header.nrx = h5readatt(fullfilename, '/', 'nrx');
    
    % Time vector for plotting
    time = linspace(0, (header.iterations)*(header.dt)*1E9, header.iterations);
    
    % Initialise structure for field arrays
    fields.ex = zeros(header.iterations, header.nrx);
    fields.ey = zeros(header.iterations, header.nrx);
    fields.ez = zeros(header.iterations, header.nrx);
    fields.hx = zeros(header.iterations, header.nrx);
    fields.hy = zeros(header.iterations, header.nrx);
    fields.hz = zeros(header.iterations, header.nrx);
    fields.ix = zeros(header.iterations, header.nrx);
    fields.iy = zeros(header.iterations, header.nrx);
    fields.iz = zeros(header.iterations, header.nrx);
    
    % Save and plot fields from each receiver
    for n=1:header.nrx
        path = strcat('/rxs/rx', num2str(n));
        tmp = h5readatt(fullfilename, path, 'Position');
        header.rx(n) = tmp(1);
        header.ry(n) = tmp(2);
        header.rz(n) = tmp(3);
        path = strcat(path, '/');
        fields.ex(:,n) = h5read(fullfilename, strcat(path, 'Ex'));
        fields.ey(:,n) = h5read(fullfilename, strcat(path, 'Ey'));
        fields.ez(:,n) = h5read(fullfilename, strcat(path, 'Ez'));
        fields.hx(:,n) = h5read(fullfilename, strcat(path, 'Hx'));
        fields.hy(:,n) = h5read(fullfilename, strcat(path, 'Hy'));
        fields.hz(:,n) = h5read(fullfilename, strcat(path, 'Hz'));
        fields.ix(:,n) = h5read(fullfilename, strcat(path, 'Ix'));
        fields.iy(:,n) = h5read(fullfilename, strcat(path, 'Iy'));
        fields.iz(:,n) = h5read(fullfilename, strcat(path, 'Iz'));
        
        fh1=figure('Name', strcat('rx', num2str(n)));
        ax1 = subplot(3,3,1); plot(time, fields.ex(:,n), 'r', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Field strength [V/m]'), title('E_x')
        ax2 = subplot(3,3,4); plot(time, fields.ey(:,n), 'r', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Field strength [V/m]'), title('E_y')
        ax3 = subplot(3,3,7); plot(time, fields.ez(:,n), 'r', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Field strength [V/m]'), title('E_z')
        ax4 = subplot(3,3,2); plot(time, fields.hx(:,n), 'b', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Field strength [A/m]'), title('H_x')
        ax5 = subplot(3,3,5); plot(time, fields.hy(:,n), 'b', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Field strength [A/m]'), title('H_y')
        ax6 = subplot(3,3,8); plot(time, fields.hz(:,n), 'b', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Field strength [A/m]'), title('H_z')
        ax7 = subplot(3,3,3); plot(time, fields.ix(:,n), 'g', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Current [A]'), title('I_x')
        ax8 = subplot(3,3,6); plot(time, fields.iy(:,n), 'g', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Current [A]'), title('I_y')
        ax9 = subplot(3,3,9); plot(time, fields.iz(:,n), 'g', 'LineWidth', 2), grid on, xlabel('Time [ns]'), ylabel('Current [A]'), title('I_z')
        ax1.FontSize = 16;
        ax2.FontSize = ax1.FontSize;
        ax3.FontSize = ax1.FontSize;
        ax4.FontSize = ax1.FontSize;
        ax5.FontSize = ax1.FontSize;
        ax6.FontSize = ax1.FontSize;
        ax7.FontSize = ax1.FontSize;
        ax8.FontSize = ax1.FontSize;
        ax9.FontSize = ax1.FontSize;
        
        % Options to create a nice looking figure for display and printing
        set(fh1,'Color','white','Menubar','none');
        X = 60;   % Paper size
        Y = 30;   % Paper size
        xMargin = 0; % Left/right margins from page borders
        yMargin = 0;  % Bottom/top margins from page borders
        xSize = X - 2*xMargin;    % Figure size on paper (width & height)
        ySize = Y - 2*yMargin;    % Figure size on paper (width & height)
        
        % Figure size displayed on screen
        set(fh1, 'Units','centimeters', 'Position', [0 0 xSize ySize])
        movegui(fh1, 'center')
        
        % Figure size printed on paper
        set(fh1,'PaperUnits', 'centimeters')
        set(fh1,'PaperSize', [X Y])
        set(fh1,'PaperPosition', [xMargin yMargin xSize ySize])
        set(fh1,'PaperOrientation', 'portrait')
    end
end