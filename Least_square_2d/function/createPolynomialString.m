function poly_str = createPolynomialString(coeff, n, m)
 % coeff: 係数のベクトル
    % n: x の最高次数
    % m: y の最高次数
    % poly_str: 出力される多項式の文字列

    % 初期化
    poly_str = ""; 
    coeff_idx = 1; % 係数のインデックス

    % x の次数ループ
    for i = 0:n
        % y の部分の初期化
        y_terms = "";

        % y の次数ループ
        for j = 0:m
            % 現在の係数
            current_coeff = coeff(coeff_idx);
            % 係数の符号を処理
            if j == 0
                if current_coeff < 0
                    y_terms = y_terms + sprintf(" - %g", abs(current_coeff)); % 負の定数項
                else
                    y_terms = y_terms + sprintf("%g", current_coeff); % 正の定数項
                end
            else
                if current_coeff < 0
                    y_terms = y_terms + sprintf(" - %g*y^%d", abs(current_coeff), j); % 負の y の項
                else
                    y_terms = y_terms + sprintf(" + %g*y^%d", current_coeff, j); % 正の y の項
                end
            end
            coeff_idx = coeff_idx + 1; % 係数インデックスを更新
        end

        % x の次数に応じて文字列を構築
        if i == 0
            poly_str = poly_str + y_terms; % x^0 の場合、y_terms のみ
        else
            if i == 1
                poly_str = poly_str + sprintf(" + x*(%s)", y_terms); % x^1 の項
            else
                poly_str = poly_str + sprintf(" + x^%d*(%s)", i, y_terms); % x^i の項
            end
        end
    end
end