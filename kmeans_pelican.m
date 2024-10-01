% Función kmeans
function [assignments, centers] = kmeans(X, k, centers = 0, maxiter = 200)
    % Tu código de k-means
    numOfRows = size(X, 1);
    numOfFeatures = size(X, 2);
    assignments = ones(numOfRows, 1);

    for iter = 1:maxiter
        clusterTotals = zeros(k, numOfFeatures);
        clusterSizes = zeros(k, 1);

        % Paralelizar aquí
        parfor rowIx = 1:numOfRows
            minDist = inf;
            assignTo = 0;
            for centerIx = 1:k
                dist = sqrt(sum((X(rowIx, :) - centers(centerIx, :)).^2));
                if dist < minDist
                    minDist = dist;
                    assignTo = centerIx;
                end
            end
            assignments(rowIx) = assignTo;

            clusterTotals(assignTo, :) += X(rowIx, :);
            clusterSizes(assignTo)++;
        end

        for clusterIx = 1:k
            if (clusterSizes(clusterIx) == 0)
                randomRow = randi([1 numOfRows]);
                clusterTotals(clusterIx, :) = X(randomRow, :);
                clusterSizes(clusterIx) = 1;
            end
        end

        newCenters = clusterTotals ./ clusterSizes;
        diff = sum(sum(abs(newCenters - centers)));

        if diff < eps
            break;
        end

        centers = newCenters;
    end

    assignments = assignments';
endfunction

% Parámetros de entrada
X = rand(100, 2);
k = 15;
maxiter = 100;

% Ejecutar kmeans
[assignments, centers] = kmeans(X, k, 0, maxiter);

% Graficar los resultados
scatter(X(:,1), X(:,2), 10, assignments);
hold on;
plot(centers(:,1), centers(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);  % Graficar centros de los clusters
title('Resultado de k-means clustering');
hold off;

% Guardar la figura
print -dpng 'resultado_kmeans.png';
