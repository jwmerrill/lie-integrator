function [pout, vout, wout] = lie_step(p, w, v, f, h)
    hat = @(a) [ 0 -a(3) a(2); a(3) 0 -a(1); -a(2) a(1) 0 ];

    ad = @(w, v) [ hat(w) zeros(3); hat(v) hat(w) ];

    C = @(w, v) eye(6) - 0.5*ad(w, v);

    bhelp = @(hw, nw) eye(3) + (1 - cos(nw))/nw^2*hw + (1 - sin(nw)/nw)*hw^2/nw^2;
    B = @(w) bhelp(hat(w), norm(w));

    tauhelp = @(hw, nw) eye(3) + sin(nw)/nw*hw + (1 - cos(nw))/nw^2*hw^2;
    tau = @(w) tauhelp(hat(w), norm(w));

    J = eye(3);
    M = eye(3);

    vupdate = @(w, v, f, h) fsolve(...
        @(wv) C(h*wv(1:3),h*wv(4:6))'*wv - C(-h*w, -h*v)'*[w, v]' - h*f',...
        [w, v]');

    pupdate = @(p, w, v, h) p*[tau(h*w) h*B(h*w)*v'; zeros(1, 3) 1];


    vu = vupdate(w, v, f, h);
    wout = vu(1:3)';
    vout = vu(4:6)';
    pout = pupdate(p, wout, vout, h);
end