 % Parámetros de entrada
X = rand(100, 2);  % 100 puntos en 2 dimensiones
k = 5;             % Número de clusters
maxiter = 100;

% Ejecutar kmeans
[assignments, centers] = kmeans(X, k, [], maxiter);  % Llamada a la función

% Mostrar resultados en una matriz
disp('Matriz de Asignaciones y Centros:');
resultMatrix = [X, assignments']; % Combina los datos originales con las asignaciones
disp('Datos Originales (X) y Asignaciones de Clusters:');
disp(resultMatrix);

disp('Centros de los Clusters:');
disp(centers);
