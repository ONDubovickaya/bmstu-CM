% метод парабол в сочетании с методом золотого сечения
function lab3()
    % очистка command window перед каждым новым запуском
    clc();
    disp('Дубовицкая Ольга Николаевна. ИУ7-21М');
    disp('Лабораторная работа №3. Вариант 4');

    % интервал [a, b] для построения функции
    a = -1;
    b = 0;
    fprintf('\n* Отрезок для построения графика целевой ф-ции [%d, %d]\n', a, b);
    % заданная точность
    eps = 1e-6;
    % задержка
    delay = 0;
    fprintf('* Заданная точность eps = %.6f\n\n', eps);

    % "дебаггинг": 1 - вывод всех р-тов; 0 - только ответ
    debuging = 1;

    % построение графика функции f на [a, b]
    fplot(@f, [a, b]);
    % возможность добавлять новые эл-ты на уже существующий график
    hold on;
    
    % вызов ф-ции метода парабол
    [x_star, f_star] = parabols(a, b, eps, debuging, delay);

    % добавление точки (x*, f(x*)) на график в виде красной точки
    scatter(x_star, f_star, 'red', 'filled');
end

function y = f(x)
    y =  tanh(5*power(x,2) + 3*x - 2) + exp((power(x,3) + 6*power(x,2) + 12*x + 8) ./ (2*power(x,2) + 8*x + 7)) - 2.0;
end

% метод золотого сечения
function [x1, x2, x3] = golden_cut(a, b, eps, debuging, delay)
    if debuging
        disp('Ищем начальные точки x1, x2, x3 с помощью метода золотого сечения');
    end
    
    % вычисление tau -- отношение длины нового отрезка к длине текущего
    tau = (sqrt(5)-1) / 2;
    % вычисление длины отрезка [a; b]
    l = b - a;
    % вычисление значений пробных точек x1 и x2
    x1 = b - tau*l;
    x2 = a + tau*l;
    % вычисление значений целевой ф-ции в точках x1 и x2
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

    while l > 2*eps
        if debuging
            disp('Сравним l (длину отрезка [a; b]) и 2*eps')
            disp('>>> l > 2*eps');
            disp('Поиск x1, x2, x3 продолжается...')
            disp(' ');
        end
        
        i = i + 1;

        if debuging
            fprintf('STEP №%2d\n', i);
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
            pause(delay);
        end

        if f1 <= f2
            b = x2;
            l = b - a;

            new_x = b - tau*l;
            new_f = f(new_x);

            if debuging
                disp('Сравним значения ф-ции в точках x1 и x2');
                disp('>>> f1 <= f2');
                disp('Отбрасываем отрезок [x2, b]');
                disp('>>> Конец b нового отрезка помещён в точку x2');
                disp('>>> Старая пробная точка х1 стала новой пробной точкой х2');
                disp('Считаем новую пробную точку x1 и значение целевой функции в ней:');
                fprintf('(х1, f1) --> x1=%.10f f1=%.10f\n', new_x, new_f);

                % добавлем на график точку (b, f(b)) в виде синего крестика
                plot(b, f(b), 'xb');
                % добавляем пунктирную линию x=b правую границу отрезка [a,b]
                line([b b], [-1 3], 'color', 'blue', 'LineStyle', '--');
                
                % соединяем отрезком точки (a, f(a)) и (b, f(b))
                % линия серая, пунктирная
                line([a b], [f(a) f(b)], 'color', [0.8 0.8 0.8], 'LineStyle', '--');

                % возможность добавлять новые эл-ты на уже существующий график
                hold on;
                % задержка
                pause(delay);
            end

            if f1 <= new_f
               x3 = x2;
               f3 = f2;

               x2 = x1;
               f2 = f1;

               x1 = new_x;
               f1 = new_f;

               if debuging
                   disp('Проверим, удовлетворяет ли новая пробная точка x1 условию ');
                   disp('>>> f1 <= new_f1, где f1 это значение ф-ции в старой пробной точке x1');
                   disp('>>> Условия выполнены');
                   disp(' ');
                   disp('Точки x1, x2, x3 найдены');
                   fprintf('>>> (x1, f1) --> x1=%.10f f1=%.10f\n', x1, f1);
                   fprintf('>>> (x2, f2) --> x2=%.10f f2=%.10f\n', x2, f2);
                   fprintf('>>> (x3, f3) --> x3=%.10f f3=%.10f\n\n', x3, f3);
               end
               break;
            end
            
            x2 = x1;
            f2 = f1;

            x1 = new_x;     
            f1 = new_f;

        else

            a = x1;
            l = b - a;

            new_x = a + tau*l;
            new_f = f(new_x);

            if debuging
                disp('Сравним значения ф-ции в точках x1 и x2');
                disp('>>> f1 > f2');
                disp('Отбрасываем отрезок [a, x1]');
                disp('>>> Конец a нового отрезка помещён в точку x1');
                disp('>>> Старая пробная точка х2 стала новой пробной точкой х1');
                disp('Считаем новую пробную точку x2 и значение целевой функции в ней:');
                fprintf('(х2, f2) --> x2=%.10f f2=%.10f\n', new_x2, new_f2);

                % добавлем на график точку (a, f(a)) в виде красного крестика
                plot(a, f(a), 'xr');
                % добавляем пунктирную линию x=a правую границу отрезка [a,b]
                line([a a], [-1 1], 'color', 'red', 'LineStyle', '--');
                
                % соединяем отрезком точки (a, f(a)) и (b, f(b))
                % линия серая, пунктирная
                line([a b], [f(a) f(b)], 'color', [0.8 0.8 0.8], 'LineStyle', '--');

                % возможность добавлять новые эл-ты на уже существующий график
                hold on;
                % задержка
                pause(delay);
            end

            if f2 <= new_f

                x1 = a; 

                x3 = new_x;
                f3 = new_f;

                if debuging
                    disp('Проверим, удовлетворяет ли новая пробная точка x2 условию ');
                    disp('>>> f2 <= new_f2, где f2 это значение ф-ции в старой пробной точке x2');
                    disp('>>> Условия выполнены');
                    disp(' ');
                    disp('Точки x1, x2, x3 найдены');
                    fprintf('>>> (x1, f1) --> x1=%.10f f1=%.10f\n', x1, f1);
                    fprintf('>>> (x2, f2) --> x2=%.10f f2=%.10f\n', x2, f2);
                    fprintf('>>> (x3, f3) --> x3=%.10f f3=%.10f\n\n', x3, f3);
                end
                break;
            end

            x1 = x2;        
            f1 = f2;

            x2 = new_x;     
            f2 = new_f;

        end
    end

    if debuging
        % отмечаем зелёными точками выбранные x1, x2, x3
        scatter(x1, f1, 'green', 'filled');
        scatter(x2, f2, 'green', 'filled');
        scatter(x3, f3, 'green', 'filled');

        % соединяем красной пунктирной линией соответствующий отрезок [x1, x3]
        line([x1 x3], [f1 f3], 'color', 'red', 'LineStyle', '--');
        hold on;
        pause(delay);
    end

    if l <= 2*eps
        if debuging
            disp('Сравним l (длину отрезка [a; b]) и 2*eps')
            disp('>>> l <= 2*eps');
            disp('x* найден с помощью метода золотого сечения');
        end
        x_star = (a+b)/2;
        f_star = f(x_star);

        fprintf('\nРезультат (для eps = %.6f):\n', eps);

        if debuging
            fprintf('%2d COUNTS\n', i);
            fprintf('a=%.10f b=%.10f\n', a, b);
        end

        fprintf('x*=%.10f, f(x*)=%.10f\n', x_star, f_star);

        % отмечаем красной точкой найденную точку минимума x*
        scatter(x_star, f_star, 'r', 'filled');
        % возврат управления к основной программе
        return;
    end
end

% метод парабол
function [x_star, f_star] = parabols(a, b, eps, debuging, delay)

    % вызов ф-ции метода золотого сечения для поиска начальных x1, x2, x3
    [x1, x2, x3] = golden_cut(a, b, eps, debuging, delay);

    if debuging
        disp('СТАРТ метода парабол');
        disp('Метод парабол на основе выбранных x1, x2, x3');
    end

    if debuging
        fprintf('[x1, x3] --> [%.10f, %.10f]\n', x1, x3);
        fprintf('>>> x1=%.10f\n', x1);
        fprintf('>>> x2=%.10f\n', x2);
        fprintf('>>> x3=%.10f\n\n', x3);
    end

    % значение целевой ф-ции в выбранных точках x1, x2, x3
    f1 = f(x1);
    f2 = f(x2);
    f3 = f(x3);

    % вычисляем коэффициенты a1 и a2 по ф-лам
    a1 = (f2 - f1) / (x2 - x1);
    a2 = ((f3 - f1)/(x3 - x1) - (f2 - f1)/(x2 - x1)) / (x3 - x2);
    % вычисляем x_ (точку минимума параболы) по ф-лам
    % и значение целевой ф-ции в ней
    x_ = 1 / 2 * (x1 + x2 - a1/a2);
    f_ = f(x_);
    % счётчик итераций
    i = 1;

    if debuging
        fprintf('\nSTEP № %2d\n', i);
        disp('Вычислим с помощью ф-л');

        fprintf('>>> Коэффициенты параболы: a1=%.10f, a2=%.10f\n', a1, a2);
        fprintf('>>> Точка минимума текущей параболы: x_=%.10f\n', x_);
        fprintf('>>> f(x_)=%.10f\n\n', f_);

        % отмечаем зелёным крестиком текущую точку минимума
        plot(x_, f_, 'xg');
        hold on;
        pause(delay);
    end

    while 1
        i = i + 1;
        previous_x_ = x_;

        if debuging
            fprintf('\nSTEP № %2d\n', i);
            disp('<< Выберем новые x1, x2, x3 >>');
        end

        if f_ > f2
            sort = f_; 
            f_ = f2; 
            f2 = sort;

            sort = x_; 
            x_ = x2; 
            x2 = sort;

            if debuging
                disp('Значение целевой ф-ции в точке x2 меньше, чем значение целевой ф-ции в точке минимума');
                disp('>>> f2 < f_');
                disp('*Меняем местами значения в соответсвующих переменных*');
            end
        end

        if x2 < x_
            x1 = x2; 
            f1 = f2;

            x2 = x_; 
            f2 = f_;

            if debuging
                disp('Точка минимума параболы расположена правее x2');
                disp('т.е. x2 < x_');
                disp(' ');
                disp('Отбрасываем отрезок [x1, x_]');
                disp('>>> Новая точка x1 помещена в старую x2');
                disp('>>> Новая точка x2 помещена в старую x_');
            end
        else
            x3 = x2; 
            f3 = f2;

            x2 = x_; 
            f2 = f_;

            if debuging
                disp('Точка минимума параболы расположена левее x2');
                disp('т.е. x_ < x2');
                disp(' ');
                disp('Отбрасываем отрезок [x2, x3]');
                disp('>>> Новая точка x2 помещена в старую x_');
                disp('>>> Новая точка x3 помещена в старую x2');
            end
        end

        if debuging
            fprintf('[x1, x3] --> [%.10f, %.10f]\n', x1, x3);

            fprintf('>>> (x1, f1) --> x1=%.10f f1=%.10f\n', x1, f1);
            fprintf('>>> (x2, f2) --> x2=%.10f f2=%.10f\n', x2, f2);
            fprintf('>>> (x3, f3) --> x3=%.10f f3=%.10f\n', x3, f3);

            fprintf('Текущая точка минимума x_: x_=%.10f, f(x_)=%.10f\n\n', x_, f_);
            
            % отмечаем красным крестиком текущую точку минимума
            plot(x_, f_, 'xr');
            hold on;
            pause(delay);
        end

        a1 = (f2 - f1) / (x2 - x1);
        a2 = ((f3 - f1)/(x3 - x1) - (f2 - f1)/(x2 - x1)) / (x3 - x2);

        x_ = 1 / 2 * (x1 + x2 - a1/a2);
        f_ = f(x_);

        if debuging
            disp('Пересчитаем коэффициенты для новой параболы и её точку минимума:');
            fprintf('>>> Коэффициенты параболы: a1=%.10f, a2=%.10f\n', a1, a2);
            fprintf('>>> Точка минимума новой параболы: x_=%.10f\n', x_);
            fprintf('>>> f(x_)=%.10f\n\n', f_);

            % отмечаем синим крестиком текущую точку минимума
            plot(x_, f_, 'xb');
            hold on;
            pause(delay);
        end

        if abs(previous_x_ - x_) <= eps
            if debuging
                disp('Сравним близость 2-ух последовательных приближений x* с eps');
                disp('>>> |previous_x_ - x_| <= eps');
                disp('x* найден')
            end
            break
        end

        if debuging
            disp('Сравним близость 2-ух последовательных приближений x* с eps');
            disp('>>> |previous_x_ - x_| > eps');
            disp('Переходим к следующей итерации');
            disp(' ');
        end
    end

    x_star = x_;
    f_star = f_;

    fprintf('\nРезультат (для eps = %.6f):\n', eps);

    if debuging
        fprintf('%2d COUNTS\n', i);
    end

    fprintf('x*=%.10f f(x*)=%.10f\n', x_star, f_star);
end
