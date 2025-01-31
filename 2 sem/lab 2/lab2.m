% Метод золотого сечения
function lab2()
    % очистка command window перед каждым новым запуском
    clc();
    disp('Дубовицкая Ольга Николаевна. ИУ7-21М');
    disp('Лабораторная работа №2. Вариант 4');

    % интервал [a, b] для построения функции
    a = -1;
    b = 0;
    fprintf('\n* Отрезок для построения графика целевой ф-ции [%d, %d]\n', a, b);
    % заданная точность
    eps = 1e-6;
    fprintf('* Заданная точность eps = %.6f\n\n', eps);

    % "дебаггинг": 1 - вывод всех р-тов; 0 - только ответ
    debuging = 1;

    % построение графика функции f на [a, b]
    fplot(@f, [a, b]);
    % возможность добавлять новые эл-ты на уже существующий график
    hold on;

    % вызов ф-ции метода золотого сечения
    [x_star, f_star] = golden_cut(a, b, eps, debuging);

    % добавление точки (x*, f(x*)) на график в виде зелёной точки
    scatter(x_star, f_star, 'green', 'filled');
end

function y = f(x)
    y =  tanh(5*power(x,2) + 3*x - 2) + exp((power(x,3) + 6*power(x,2) + 12*x + 8) ./ (2*power(x,2) + 8*x + 7)) - 2.0;
end

function [x_star, f_star] = golden_cut(a, b, eps, debuging)
    % вычисление tau -- отношение длины нового отрезка к длине текущего
    tau = (sqrt(5) - 1) / 2;
    % вычисление длины отрезка [a; b]
    l = b - a;
    % вычисление значений пробных точек x1 и x2
    x1 = b - tau * l;
    x2 = a + tau * l;
    % вычисление значений целевой функции в точках х1 и х2
    f1 = f(x1);
    f2 = f(x2);
    % счётчик вычислений
    i = 0;
    % выводятся посчитанные x1, f1 и x2, f2
    if debuging
        fprintf('STEP №%d\n', i);
        disp('Вычислим пробную точку x1 по формуле x1 := b - tau * l');
        disp('Пробная точка x1 и значение целевой функции в ней:');
        fprintf('>>> (x1, f1) --> x1=%.10f f1=%.10f\n\n', x1, f1);

        disp('Вычислим пробную точку x2 по формуле x2 := a + tau * l');
        disp('Пробная точка x2 и значение целевой функции в ней:');
        fprintf('>>> (x2, f2) --> x2=%.10f f2=%.10f\n\n', x2, f2);
    end

    while 1
        i = i + 1;

        if debuging
            fprintf('\nSTEP №%2d\n', i);
            fprintf('<<< a=%.10f b=%.10f >>>\n', a, b);

            % добавлем на график точку (a, f(a)) в виде красного крестика
            plot(a, f(a), 'xr');
            % добавляем пунктирную линию x=a левую границу отрезка [a,b]
            line([a a], [-1 1], 'color', 'red', 'LineStyle', '--');

            % добавлем на график точку (b, f(b)) в виде синего крестика
            plot(b, f(b), 'xb');
            % добавляем пунктирную линию x=b правую границу отрезка [a,b]
            line([b b], [-1 1], 'color', 'blue', 'LineStyle', '--');

            % соединяем отрезком точки (a, f(a)) и (b, f(b))
            % линия серая, пунктирная
            line([a b], [f(a) f(b)], 'color', [0.8 0.8 0.8], 'LineStyle', '--');

            % возможность добавлять новые эл-ты на уже существующий график
            hold on;
            % задержка
            %pause(0.8);
        end

        if l > 2 * eps
            if debuging
                disp('Сравним l (длину отрезка [a; b]) и 2*eps')
                disp('>>> l > 2*eps');
                disp(' ');
                disp('Сравним значения функции в точках x1 и x2');
            end

            if f1 <= f2
                b = x2;
                l = b - a;

                x2 = x1;
                f2 = f1;

                x1 = b - tau * l;
                f1 = f(x1);

                if debuging
                    disp('>>> f1 <= f2');
                    disp(' ');
                    disp('Отбрасываем отрезок [x2, b]');
                    disp('>>> Конец b нового отрезка помещён в точку x2');
                    disp('>>> Старая пробная точка х1 стала новой пробной точкой х2');
                    disp('Считаем новую пробную точку x1 и значение целевой функции в ней:');
                    fprintf('(х1, f1) --> x1=%.10f f1=%.10f\n', x1, f1);
                end
            else
                a = x1;
                l = b - a;

                x1 = x2;
                f1 = f2;

                x2 = a + tau * l;
                f2 = f(x2);

                if debuging
                    disp('>>> f1 > f2');
                    disp(' ');
                    disp('Отбрасываем отрезок [a, x1]');
                    disp('>>> Конец a нового отрезка помещён в точку x1');
                    disp('>>> Старая пробная точка х2 стала новой пробной точкой х1');
                    disp('Считаем новую пробную точку x2 и значение целевой функции в ней:');
                    fprintf('(х2, f2) --> x2=%.10f f2=%.10f\n', x2, f2);
                end
            end
        else
            if debuging
                disp('Сравним длину отрезка l и 2*eps')
                disp('>>> l <= 2*eps');
                disp('x* найден');
            end

            x_star = (a + b) / 2;
            f_star= f(x_star);
            break
        end
    end

    i = i + 1;

    fprintf('\nРезультат (для eps = %.6f):\n', eps);

    if debuging
        fprintf('%2d COUNTS\n', i);
        fprintf('a=%.10f b=%.10f\n', a, b);
    end

    fprintf('x*=%.10f f(x*)=%.10f\n', x_star, f_star);
    line([a b], [f(a) f(b)], 'color', 'red');
end
