% Función kmeans
function [assignments, centers] = kmeans(X, k, centers = [], maxiter = 200)
    % Parámetros de entrada
    numOfRows = size(X, 1);
    numOfFeatures = size(X, 2);
    assignments = ones(numOfRows, 1);

    % Inicializar los centros aleatoriamente si no se proporcionan
    if isempty(centers)
        centers = X(randperm(numOfRows, k), :); % Escoge k puntos aleatorios de X
    end

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

            % Se usa una variable temporal para la actualización fuera del parfor
            clusterTotals(assignTo, :) += X(rowIx, :);
            clusterSizes(assignTo)++;
        end

        % Reinitialize empty clusters
        for clusterIx = 1:k
            if (clusterSizes(clusterIx) == 0)
                randomRow = randi([1 numOfRows]);
                clusterTotals(clusterIx, :) = X(randomRow, :);
                clusterSizes(clusterIx) = 1; % Asignar tamaño a 1 para evitar división por cero
            end
        end

        newCenters = clusterTotals ./ clusterSizes;

        % Cálculo de la diferencia entre los nuevos y viejos centros
        diff = sum(sum(abs(newCenters - centers)));

        if diff < eps
            break; % Si la diferencia es menor que el umbral, termina
        end

        centers = newCenters; % Actualiza los centros
    end

    assignments = assignments'; % Transponer asignaciones para salida
endfunction



