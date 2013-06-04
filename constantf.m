p = eye(4);
v = [-10, 0, 0];
w = [0, 0, 0];

f = [0, 0, 1, 2, 3, 0];
h = .001;

position = zeros(100, 2);
velocity = zeros(100, 2);
for i = 1:100
    [p, v, w] = lie_step(p, v, w, f, h);
    position(i, :) = p(1:2, 4);
    velocity(i, :) = v(1:2)';
end

figure(1)
plot(position(:, 1), position(:, 2))
figure(2)
plot(velocity(:, 1), velocity(:, 2))