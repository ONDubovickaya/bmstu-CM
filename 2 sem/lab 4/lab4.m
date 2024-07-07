% модифицированный метод Ньютона
function lab4()
    % очистка command window перед каждым новым запуском
    clc();
    disp('Дубовицкая Ольга Николаевна. ИУ7-21М');
    disp('Лабораторная работа №4. Вариант 4');

    % интервал [a, b] для построения ф-ции
    a = -1;
    b = 0;
    fprintf('\n* Отрезок для построения графика целевой ф-ции [%d, %d]\n', a, b);
    % заданная точность
    eps = 1e-6;
    fprintf('* eps = %.6f (заданная точность)\n', eps);
    % коэффициент для конечно-разностной аппроксимации производных
    delta = 1e-8;
    fprintf('* delta = %.6f (для конечно-разностной аппроксимации производных)\n\n', delta);

    % "дебаггинг": 1 - вывод всех р-тов; 0 - только ответ
    debuging = 1;
    % задержка
    delay = 0;
    
    % построение графика ф-ции f на [a, b]
    fplot(@f, [a, b]);
    % возможность добавлять новые эл-ты на уже существующий график
    hold on;

    % вызов ф-ции модифицированного метода Ньютона
    [x_star, f_star] = newton_modif(a, b, eps, delta, debuging, delay);

    % добавление точки (x*, f(x*)) на график в виде зелёной точки
    scatter(x_star, f_star, 'green', 'filled');

    % результаты вычисления с помощью fminbnd
    [x_res, f_res] = fminbnd(@f, a, b);
    disp('Результат поиска точки минимума с помощью ф-ции fminbnd:')
    fprintf('x*=%.10f, f(x*)=%.10f\n', x_res, f_res);
    scatter(x_res, f_res, 'red', 'filled');
end

function y = f(x)
    y =  tanh(5*power(x,2) + 3*x - 2) + exp((power(x,3) + 6*power(x,2) + 12*x + 8) ./ (2*power(x,2) + 8*x + 7)) - 2.0;
end

% ф-ция для нахождения 1-ой производной
function f1 = first_derivative(x, delta)
    f_decrement = f(x - delta);
    f_increment = f(x + delta);
    
    f1 = (f_increment - f_decrement) / (2 * delta);
end

% ф-ция для нахождения 2-ой производной
function f2 = second_derivative(x, delta)
    f_decrement = f(x - delta);
    f_increment = f(x + delta);
    
    f2 = (f_increment - 2*f(x) + f_decrement) / (power(delta, 2));
end

% модифицированный метод Ньютона
function [x_star, f_star] = newton_modif(a, b, eps, delta, debuging, delay)
    x_ = 3 * (a + b) / 4;
    fprintf('Начальное приближение точки минимума: x_ = %.10f\n', x_);

    i = 1;
    f_diff2 = second_derivative(x_, delta);

    while 1
        f_diff1 = first_derivative(x_, delta);
        f_ = f(x_);
        
        if debuging
            fprintf('\nSTEP №%d\n', i);
            fprintf("Значение 1-ой производной в точке x_: f'(x_)=%.10f\n", f_diff1);

            plot(x_, f_, 'xb');
            hold on;
            pause(delay);
        end

        if debuging
            disp('Сравним модуль значения 1-ой производной в точке x_ с eps');
        end

        if abs(f_diff1) < eps
            if debuging
                disp(">>> |f'(x_)| < eps");
                disp('x* найден');
            end
            
            break;
        end

        if debuging
            disp(">>> |f'(x_)| >= eps");
            disp('Продолжаем поиск x*...');
        end

        x_ = x_ - f_diff1 / f_diff2;

        if debuging
            fprintf("\nЗначение 2-ой производной в точке x_: f''(x_)=%.10f\n\n", f_diff2);
            disp("Пересчитываем значение приближения точки минимума");
            fprintf(">>> Новое значение: x_ = %.10f\n\n", x_);
        end

        i = i + 1;
    end

    x_star = x_;
    f_star = f(x_);

    fprintf('\nРезультат (для eps = %.6f):\n', eps);

    if debuging
        fprintf('%2d COUNTS\n', i);
    end

    fprintf('x*=%.10f f(x*)=%.10f\n\n', x_star, f_star);
end
