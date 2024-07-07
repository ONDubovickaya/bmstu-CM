% Метод поразрядного поиска
function lab1()
    % очистка command window перед каждым новым запуском
    clc();

    disp('Дубовицкая Ольга Николаевна. ИУ7-21М');
    disp('Лабораторная работа №1. Вариант 4');

    % "дебаггинг": 1 - вывод всех р-тов; 0 - только ответ
    debugFlg = 1;

    % задержка
    delayS = 0;

    % отрезок [a, b] для построения графика функции
    a = -1;
    b = 0;
    fprintf('\n* Отрезок для построения графика целевой ф-ции [%d, %d]\n', a, b);
    % погрешность
    eps = 1e-6;
    fprintf('* Заданная точность eps = %.6f\n\n', eps);

    % построение графика функции f на [a, b]
    fplot(@f, [a, b]);
    % возможность добавлять новые эл-ты на уже существующий график
    hold on;
    
    % вызов ф-ции поразрядного поиска 
    [xStar, fStar] = bitwiseSearch(a, b, eps, debugFlg, delayS);

    % добавление точки (x*, f(x*)) на график в виде красной точки
    scatter(xStar, fStar, 'r', 'filled');
end

function [x0, f0] = bitwiseSearch(a, b, eps, debugFlg, delayS)
    % счётчик вычислений
    i = 0;
    
    % инициализация начальной точки
    x0 = a;
    % вычисление значения функции в начальной точке
    f0 = f(x0);

    % выводятся посчитанные x0 и f0
    if debugFlg
        disp('Начальная точка и значение целевой ф-ции в ней:');
        fprintf('STEP №%d (x0, f0) --> x0=%.10f f0=%.10f\n\n', i, x0, f0);
    end

    % вычисление delta
    delta = (b - a) / 4;
    if debugFlg
        disp('Вычисляем значение delta = (b-a)/4 :');
        fprintf('>>> delta=%.10f\n\n', delta);
    end

    plot_x = [];
    plot_f = [];

    while 1
        i = i + 1;
        % итеративно изменим точку x0
        x1 = x0 + delta;
        % вычисление значения фукнции в новой точке
        f1 = f(x1);

        if debugFlg
            % выводятся посчитанные x1 и f1
            disp(' ');
            disp('Новая точка x1 и значение целевой ф-ции в ней:');
            fprintf('STEP №%2d (x1, f1) --> x1=%.10f f1=%.10f\n\n', i, x1, f1);

            % добавляем новые значения в соответствующие массивы
            plot_x(end + 1) = x1;
            plot_f(end + 1) = f1;

            % строим график, используя массивы 
            % график с маркерами в форме крестиков (х) и чёрным цветом (k)
            plot(plot_x, plot_f, 'xk');

            % добавлем на график точку (x1, f1)
            % в виде красного крестика
            plot(x1, f1, 'xr');
            % возможность добавлять новые эл-ты на уже существующий график
            hold on;
            % приостановка программы на delayS секунд
            % (чтобы изменения на графики происходили с некоторой задержкой)
            pause(delayS);
        end

        % если значение функции в новой точке меньше чем в текущей
        if f0 > f1
            if debugFlg
                disp('Сравним значения ф-ции f0 (в текущей точке) и f1 (в новой точке):');
                fprintf('f0=%.10f\n', f0);
                fprintf('f1=%.10f\n', f1);
                disp('>>> f0 > f1');
                disp('>>> Значение функции в новой точке меньше, чем в текущей');
                disp(' ');
                disp('Проверим, лежит ли x1 в интервале (a, b):');
            end
            
            if a < x1 && x1 < b
                if debugFlg
                    disp('>>> x1 принадлежит (a; b)');
                    disp(' ');
                    fprintf('Теперь x0 := x1 = %.10f; f0 := f1 = %.10f\n', x1, f1);
                    fprintf('delta остаётся прежним: delta=%.10f\n', delta);
                end
                x0 = x1;
                f0 = f1;
                continue
            else
                if debugFlg
                    disp('>>> x1 лежит вне (a;b)');
                    disp(' ');
                    disp('Сравним |delta| с eps:');
                end

                if abs(delta) < eps
                    if debugFlg
                        disp('>>> |delta| < eps');
                        disp(' ');
                        disp('x* найден');
                    end
                    break;
                else
                    delta = -delta / 4;

                    if debugFlg
                        disp('>>> |delta| >= eps');
                        disp (' ');
                        disp('Уменьшаем delta в 4 раза и меняем направление шага:');
                        fprintf('>>> delta=%.10f\n', delta);
                    end
                    
                    x0 = x1;
                    f0 = f1;
                end
            end
        % иначе уменьшаем шаг и продолжаем поиск
        else
            if debugFlg
                disp('Сравним значения ф-ции f0 (в текущей точке) и f1 (в новой точке):');
                fprintf('f0=%.10f\n', f0);
                fprintf('f1=%.10f\n', f1);
                disp('>>> f0 < f1');
                disp('>>> Значение функции в новой точке больше, чем в текущей');
                disp(' ');
                disp('Сравним |delta| с eps:');
            end

            if abs(delta) < eps
                if debugFlg
                    disp('>>> |delta| < eps');
                    disp('x* найден');
                end
                break;
            else
                delta = -delta / 4;
                
                if debugFlg
                    disp('>>> |delta| >= eps');
                    disp('Уменьшаем delta в 4 раза и меняем направление шага:');
                    fprintf('>>> delta=%.10f\n', delta);
                end
                
                x0 = x1;
                f0 = f1;
            end
        end
    end

    i = i + 1;
    if debugFlg
        fprintf('\n%2d COUNTS --> x*=%.10f f(x*)=%.10f\n', i, x0, f0);
    end

    fprintf('Результат (для eps = %.6f): x*=%.10f f(x*)=%.10f\n', eps, x0, f0);
    plot(plot_x, plot_f, 'xk');
end

function y = f(x)
    y =  tanh(5*power(x,2) + 3*x - 2) + exp((power(x,3) + 6*power(x,2) + 12*x + 8) ./ (2*power(x,2) + 8*x + 7)) - 2.0;
end
