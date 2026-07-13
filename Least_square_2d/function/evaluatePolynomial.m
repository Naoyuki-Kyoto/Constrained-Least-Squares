function Z_fit = evaluatePolynomial(coeff, X_fit, Y_fit, n, m)
    % 入力:
    % coeff: 多項式の係数ベクトル (1D配列)
    % X_fit, Y_fit: 入力データのメッシュグリッド
    % n: x の最大次数
    % m: y の最大次数
    % 出力:
    % Z_fit: 多項式で評価された z の値 (同じ形状の配列)
    
    % Z_fit を初期化（X_fitと同じ形状）
    Z_fit = zeros(size(X_fit));
    
    % 係数を使って Z_fit を計算
    col = 1; % coeff のインデックス
    for i = 0:n
        for j = 0:m
            Z_fit = Z_fit + coeff(col) * (X_fit.^i) .* (Y_fit.^j);
            col = col + 1;
        end
    end
end