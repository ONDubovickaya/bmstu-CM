% Основной скрипт
function Lab1()
    clc;
    % Объявление переменных и создание исходной матрицы стоимостей
    
    % флаг для активации "отладочного" варианта программы 
    % (активируется значением 1)
    % аналогичный есть в функции 10 и 12, отмечаем одновременно
    debugVar = 1;
    % флаг для активации задачи максимизации 
    % (активируется значением 1)
    zadMax = 0;
    
    % исходная матрица стоимостей, вариант 3
    matr = [
        1 4 7 9 4; 
        9 3 8 7 4; 
        3 4 6 8 2; 
        8 2 4 6 7; 
        7 6 9 8 5];
    
    % Вывод информации о лабораторной работе
    disp('Дубовицкая Ольга Николаевна. ИУ7-11М');
    disp('Лабораторная работа №1. Вариант 3');
    
    % Вывод исходной матрицы стоимостей
    disp('Исходная матрица стоимостей:');
    disp(matr);
    
    % Вывод преобразованной матрицы стоимостей после приведения исходной 
    % задачи о назначениях к эквивалентной, если zadMax=1
    C = matr;
    if zadMax == 1
        C = convertToMIN(C);
        disp('Матрица стоимостей после приведения к задаче минимизации:');
        disp(C);
    end
    
    % реализация Венгерского метода
    % шаг 1. Вычитание из каждого столбца матрицы соответствующего ему min
    % элемента
    C = updateMatrColumns(C);
    if debugVar == 1
        disp('Матрица стоимостей после вычитания наименьших элементов по столбцам:');
        disp(C);
    end
    % шаг 2. Вычитание из каждой строки матрицы соответствующего ему min
    % элемента
    C = updateMatrRows(C);
    if debugVar == 1
        disp('Матрица стоимостей после вычитания наименьших элементов по строкам:');
        disp(C);
    end
    % Возвращение значений количества строк и столбцов для матрицы C
    [numRows,numCols] = size(C);
    % шаг 3. Построение начальной системы независимых нулей (СНН)
    matrCHH = initCHH(C);
    if debugVar == 1
        disp('Начальная СНН:');
        printCHH(C, matrCHH);
    end
    % шаг 4. Определяем, нужно ли улучшать матрицу C
    % находим количество нулей в СНН
    k = sum(matrCHH, 'all'); 
    if debugVar == 1 
        fprintf('Число нулей в построенной СНН: k = %d\n\n', k);
        if k == length(C)
            fprintf('|СНН| = %d = n => улучшать не нужно\n\n', k);
        else
            fprintf('|СНН| = %d < %d = n => нужно улучшать\n\n', k, length(C));
        end    
    end
    
    % цикл для случая, если нужно улучшать
    while k < numCols 
        if debugVar == 1
            disp('НАЧАЛО ИТЕРАЦИИ');
        end
        % создаём матрицу из нулей, которая будет использоваться для
        % маркирования
        markMatr = zeros(numRows, numCols); 
        
        % считаем сумму каждого столбца матрицы matrCHH
        % (массив из сумм элементов каждого столбца)
        % (1 - суммы у столбцов с 0*)
        selectedColumns = sum(matrCHH);
        
        % создаём массив из нулей
        selectedRows = zeros(numRows); 
        
        % отметим столбцы, которые содержат 0*
        % (матрица с единицами в столбцах, соответствующих выделенным)
        selection = getSelection(numRows, numCols, selectedColumns); 
        
        % вывод символов "+" для выделенных столбцов и строк
        if debugVar == 1  
            disp('Отметим столбцы, содержащие 0*, символом "+" (будем называть их выделенными):'); 
            printMarkedMatr(C, matrCHH, markMatr, selectedColumns, selectedRows); 
        end 
        
        % рассмотрим невыделенные элементы

        % флаг для обозначения перехода к построению L-цепочки
        % (перейдём к построению, когда значение изменится на false)
        flag = true; 
        
        % объявление массива для индексов первого 0, найденного среди 
        % невыделенных элементов
        indFirstZero = [-1 -1]; 
        % цикл для работы с невыделенными элементами
        while flag  
            if debugVar == 1  
                disp('Определим, есть ли 0 среди невыделенных элементов?'); 
            end 
            
            % поиск индексов первого 0 по столбцам (сверху вниз, слева направо) 
            % среди невыделенных элементов
            indFirstZero = findZero(C, selection); 
            
            % преобразование матрицы C в случае, когда среди невыделенных
            % элементов нет нулей
            if indFirstZero(1) == -1 
                C = updateMatrNoZero(C, numRows, numCols, selection, selectedRows, selectedColumns); 
                if debugVar == 1
                    disp('Преобразованная матрица:');
                    disp('(сначала h вычли из всех невыделенных столбцов, а затем добавили его к выделенным строкам)');
                    printMarkedMatr(C, matrCHH, markMatr, selectedColumns, selectedRows); 
                end 
                indFirstZero = findZero(C, selection); 
            end 
            
            % в маркерованной матрице найденный ноль заменяем на 1
            markMatr(indFirstZero(1), indFirstZero(2)) = 1; 
            if debugVar == 1  
                disp('Среди невыделенных элементов есть 0 => попробуем включить его в СНН => отметим его 0'''); 
                printMarkedMatr(C, matrCHH, markMatr, selectedColumns, selectedRows); 
            end 
            
            % проверяем, есть ли 0* в одной строке с 0'
            zeroStarInRow = getZeroStarInRow(indFirstZero, numCols, matrCHH); 
            if zeroStarInRow(1) == -1 
                flag = false;
                if debugVar == 1
                    disp('В одной строке с 0'' нет 0* => строим L-цепочку:');
                    disp('текущий 0'' --(по столбцу)--> 0* --(по строке)--> 0'' --(по столбцу)--> ... --(по строке)--> 0''');
                end
            else 
                selection(:, zeroStarInRow(2)) = selection(:, zeroStarInRow(2)) - 1; % из выбранных столбцов вычтем 1
                selectedColumns(zeroStarInRow(2)) = 0; % в выбранный столбец установим 0
                selection(zeroStarInRow(1), :) = selection(zeroStarInRow(1), :) + 1;  % к выбранным строкам прибавим 1
                selectedRows(zeroStarInRow(1)) = 1; % в выбранную строку установим 1
                if debugVar == 1  
                    disp('В одной строке с 0'' есть 0* => перебрасываем выделение'); 
                    disp('(снимаем выделение со столбца с 0* и выделяем строку с 0'')');
                    printMarkedMatr(C, matrCHH, markMatr, selectedColumns, selectedRows); 
                end 
            end 
        end
        % построение L-цепочки
        if debugVar == 1
           disp('(ПРИМЕЧАНИЕ: в записи [i, j] i - номер строки, j - номер столбца)'); 
           disp('Построенная L-цепочка:');
        end 
        [markMatr, matrCHH] = createL(numRows, numCols, indFirstZero, markMatr, matrCHH); 
        k = sum(matrCHH, 'all');
        if debugVar == 1
            disp('Выполним преобразования в пределах L-цепочки: 1) 0* -> 0; 2) 0'' -> 0*; 3) снимаем все выделения, кроме 0*');
            disp('Текущая СНН:'); 
            printCHH(C, matrCHH);  
            fprintf('Число нулей в построенной СНН: k = %d\n\n', k);
            if k == length(C)
                fprintf('|СНН| = %d = n => улучшать не нужно\n', k);
                fprintf('КОНЕЦ ИТЕРАЦИИ\n\n');
            else
                fprintf('|СНН| = %d < %d = n => нужно улучшать\n', k, length(C));
                fprintf('КОНЕЦ ИТЕРАЦИИ\n\n');
            end
        end
    end
    
    % вывод результатов выполнения Венгерского метода
    % вывод матрицы стоимостей с конечной системой независимых нулей
    if debugVar == 1
        disp('Конечная СНН:'); 
        printCHH(C, matrCHH);
    end
    % вывод оптимального решения задачи о назначениях
    disp('opt-решение x_opt данной задачи о назначениях:');
    disp('(матрица назначений X)'); 
    %disp('x_opt ='); 
    disp(matrCHH);
    % вывод оптимального значения функции f, т.е минимальной/максимальной
    % стоимости выполнения всех работ
    disp('opt-значение функции f:');
    fOpt = valueFOpt(matr, matrCHH); 
    if zadMax == 0
        disp('т.е минимальная стоимость выполнения всех работ:');
    elseif zadMax == 1
        disp('т.е максимальная стоимость выполнения всех работ:');
    end    
    fprintf("f opt = f (x_opt) = %d\n\n", fOpt); 
end

% Функция 1 (приведение задачи максимизации к задаче минимизации)
function matr = convertToMIN(matr)
    % Реализация функции
    maxElem = max(max(matr));
    matr = matr * (-1) + maxElem;
end

% Функция 2 (вычитание наименьших элементов по столбцам)
function matr = updateMatrColumns(matr)
    minElemArr = min(matr); % массив из минимальных элементов каждого столбца
    % цикл по столбцам
    for j = 1 : length(minElemArr)
        matr(:, j) = matr(:, j) - minElemArr(j);
    end
end

% Функция 3 (вычитание наименьших элементов по строкам)
function matr = updateMatrRows(matr)
    minElemArr = min(matr,[],2); % массив из минимальных элементов каждой строки
    % цикл по строкам
    for i = 1 : length(minElemArr)
        matr(i, :) = matr(i, :) - minElemArr(i);
    end
end

% Функция 4 (создание матрицы, соответствующей СНН (0* соответствует 1))
function matrCHH = initCHH(matr)
    % получаем размеры входной матрицы
    [numRows,numCols] = size(matr); 
    % создаём новую матрицу того же размера, заполненную нулями
    matrCHH = zeros(numRows, numCols);
    % проход по матрице сверху вниз, слева направо
    for i = 1: numCols 
        for j = 1 : numRows
            % для каждого нулевого элемента входной матрицы matr выполняем следующее
            if matr(j, i) == 0 
                count = 0; 
                % перебор всех столбцов
                for k = 1 : numCols 
                   count = count + matrCHH(j, k); 
                end 
                % перебор всех строк
                for k = 1 : numRows 
                   count = count + matrCHH(k, i); 
                end 
                % для нулевой суммы (i,j)-элемент становится единицей
                if count == 0  
                    matrCHH(j, i) = 1; 
                end  
            end 
        end  
    end 
end 

% Функция 5 (вывод матрицы с отметками 0* в соответствии с СНН)
function [] = printCHH(matr, matrCHH) 
    [numRows,numCols] = size(matr); 
    for i = 1 : numRows 
        for j = 1 : numCols 
            if matrCHH(i, j) == 1 
                fprintf("\t%d*\t", matr(i, j)); 
            else 
                fprintf("\t%d\t", matr(i, j)); 
            end 
        end 
        fprintf("\n"); 
    end 
    fprintf("\n"); 
end

% Функция 6 (вычисление opt-значения функции f)
function [fOpt] = valueFOpt(matr, matrCHH) 
    fOpt = 0; 
    [numRows,numCols] = size(matr); 
    data = zeros(numCols);
    separator = ' + ';
    % складываем по столбцам значения, соответствующие 1 в matrCHH
    for i = 1 : numCols 
        for j = 1 : numRows 
            if matrCHH(j, i) == 1  
                fOpt = fOpt + matr(j, i);
                data(i) = matr(j, i);
            end 
        end 
    end
    for i = 1:length(data)
        if i < length(data)
            fprintf('%d%s', data(i), separator);
        else
            fprintf('%d = %d\n', data(i), fOpt);
        end
    end
end

% ФУНКЦИИ ДЛЯ УЛУЧШЕНИЯ МАТРИЦЫ СТОИМОСТЕЙ
% Функция 7 (создание матрицы, отмечающей выделенные столбцы единицами)
function [selection] = getSelection(numRows, numCols, selectedColumns) 
    selection = zeros(numRows, numCols); 
    % заполняем единицами столбцы, которые соответствуют selectedColumns
    for j = 1 : numCols 
        if selectedColumns(j) == 1  
            selection(:, j) = selection(:, j) + 1; 
        end  
    end 
end 

% Функция 8 (вывод маркированной матрицы)
function [] = printMarkedMatr(matr, matrCHH, markMatr, selectedColumns, selectedRows) 
    [numRows,numCols] = size(matr); 
    for i = 1 : numRows 
        if selectedRows(i) == 1 
            fprintf("+") 
        end 
        for j = 1 : numCols 
            fprintf("\t%d", matr(i, j)) 
            if matrCHH(i, j) == 1  
                fprintf("*\t"); 
            elseif markMatr(i, j) == 1 
                fprintf("'\t") 
            else 
                fprintf("\t"); 
            end 
        end 
        fprintf('\n'); 
    end 
    for i = 1 : numCols 
        if selectedColumns(i) == 1 
            fprintf("\t+\t") 
        else  
            fprintf(" \t\t") 
        end  
    end 
    fprintf('\n\n'); 
end

% Функция 9 (поиск индексов первого 0 среди невыделенных элементов) 
function [indFirstZero] = findZero(matr, selection)  
    indFirstZero = [-1 -1]; 
    [numRows,numCols] = size(matr); 
    for i = 1 : numCols 
        for j = 1 : numRows 
           if selection(j, i) == 0 && matr(j, i) == 0  
                indFirstZero(1) = j; 
                indFirstZero(2) = i; 
                return; % возвращаем управление вызывающему скрипту
           end 
        end  
    end 
end 

% Функция 10 (преобразование матрицы, у которой нет 0 среди невыделенных
% элементов)
function [matr] = updateMatrNoZero(matr, numRows, numCols, selection, selectedRows, selectedColumns) 
    debugVar = 1;
    h = 1e5; % Наименьший элемент среди невыделенных 
    for j = 1 : numCols 
        for i = 1 : numRows 
            % для элементов матрицы, которые среди невыделенных, 
            % т.е это 0 в selection
            if selection(i, j) == 0 && matr(i, j) < h 
                h = matr(i, j); 
            end 
        end  
    end
    if debugVar == 1
        disp('Среди невыделенных элементов нет нулей => нужно преобразовать матрицу');
        fprintf('Наименьший элемент среди невыделенных: h = %d\n\n', h);
    end
    for j = 1 : numCols 
        if selectedColumns(j) == 0 
            matr(:, j) = matr(:, j) - h; 
        end  
    end 
    for i = 1 : numRows 
        if selectedRows(i) == 1 
            matr(i, :) = matr(i, :) + h; 
        end  
    end 
end 

% Функция 11 (поиск 0* в одной строке c 0')
function [zeroStarInRow] = getZeroStarInRow(indFirstZero, numCols, matrCHH) 
    i = indFirstZero(1); 
    zeroStarInRow = [-1 -1]; 
    for j = 1 : numCols 
       if matrCHH(i, j) == 1 
           zeroStarInRow(1) = i; 
           zeroStarInRow(2) = j; 
           break % завершение цикла
       end  
    end 
end 

% Функция 12 (построение L-цепочки)
function [markMatr, matrCHH] = createL(numRows, numCols, indFirstZero, markMatr, matrCHH) 
    debugVar = 1;
    i = indFirstZero(1); 
    j = indFirstZero(2); 
    while i > 0 && j > 0 && i <= numRows && j <= numCols 
        markMatr(i, j) = 0; 
        matrCHH(i, j) = 1; 
        if debugVar == 1
            fprintf("[%d, %d] ", i, j); % сначала текущий, затем просто 0'
        end
        kRow = 1; 
        while kRow <= numRows  && (matrCHH(kRow, j) ~= 1 || kRow == i) 
            kRow = kRow + 1; 
        end 
 
        if (kRow <= numRows)   
            lCol = 1; 
            while lCol <= numCols && (markMatr(kRow, lCol) ~= 1 || lCol == j) 
                lCol = lCol + 1; 
            end 
            % вывод для 0*
            if lCol <= numCols 
                matrCHH(kRow,j) = 0; 
                if debugVar == 1
                    fprintf("-> [%d, %d] -> ", kRow, j);
                end
            end 
            j = lCol; 
        end 
        i = kRow; 
    end
    if debugVar == 1
        fprintf('\n\n');
    end
end 
