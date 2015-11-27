function [d T] = pca(data,flag1,nplots,names,flag2)

%PCA - Principal Component Analysis
%   [d U] = pca(DATA, FLAG1=0, NPLOTS=0, NAMES={}, FLAG2=0)
%
%   Rows of DATA represent observations.
%   Columns of DATA represent variables.
%
%   FLAG1 is 0 for no scaling (default) and 1 for scaling.
%
%   NPLOTS is the number of components plotted (default is 0).
%
%   NAMES is cell array with variables labels (default is {}).
%
%   FLAG2 is 0 to plot only variable projection (default) and 1 to plot
%   also observations projections.
%
%   [d U] = pca(...) returns :
%       d : the percentage of variance
%       U : the coordinates of components

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-06-30
% CNRS - Universite Lyon 1, UMR 5020
%--------------------------------------------------------------------------
%   $Revision: 1.1 $ $Date: 2007-07-02 12:15:43 $
%--------------------------------------------------------------------------

if nargin<2
    flag1 = 0;
end

if nargin <3
    nplots = 0;
end

if nargin <4
    names = {};
end

if nargin <5
    flag2 = 0;
end

[nR nC] = size(data);

disp([int2str(nR) ' observations, ' int2str(nC) ' factors.']);

% Data is centered
M = mean(data, 1);
data = data - repmat(M, nR, 1);

if flag1 == 1
    % Data must be scaled
    S = std(data, 0, 1);
    data = data ./ repmat(S, nR, 1);
end

% Correlation
C = (data' * data) / (nR-1);

% Eigen value decomposition
[U D V] = svd(C);
T = U*sqrt(D);
data_proj = data * U;
d = diag(D);
d = d.^2 / sum(d.^2) * 100;

% Names
names_ = {};
for i=1:nC
    if length(names)>=i
        names_{i} = names{i};
    else
        names_{i} = '';
    end
end

% Plots
for i=1:nplots
    subplot(flag2+1,nplots,i);
    plot(cos(linspace(0, 2*pi, 50)), sin(linspace(0, 2*pi, 50)), 'r')
    hold on
    plot([-1 1; 0 0]', [0 0; -1 1]', ':k');
    x = T(:,i);
    y = T(:,i+1);
    plot([x x*0]',[y y*0]','-ok')
    text(x+.05, y+.05, names_);
    hold off
    ylim([-1 1]*1.1)
    xlim([-1 1]*1.1)
    xlabel(['Factor ' int2str(i) ' (' num2str(d(i)) '%)'])
    ylabel(['Factor ' int2str(i+1) ' (' num2str(d(i+1)) '%)'])
end

if flag2==1
    for i=1:nplots
        subplot(flag2+1,nplots,nplots+i);
        x = data_proj(:,i);
        y = data_proj(:,i+1);
        plot([min(x(:)) max(x(:)); 0 0]'*1.1, [0 0; min(y(:)) max(y(:))]'*1.1, ':k');
        hold on
        plot(x, y,'+');
        hold off
        xlabel(['Factor ' int2str(i) ' (' num2str(d(i)) '%)'])
        ylabel(['Factor ' int2str(i+1) ' (' num2str(d(i+1)) '%)'])
    end
end
