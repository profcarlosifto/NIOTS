function escreve_ens(ensemble, arquivo)
% Função que escreve o resultado dos ensembles melhores que sua parte no
% arquivo
% ensemble -> estrutura com os dados dos ensembles
% arquivo  -> nome do arquivo relatório

if ~isempty(ensemble)
    m = length(ensemble);
    FileID = fopen(arquivo, 'w+');
    if (FileID == -1)
        disp(['Cannot open file: ' arquivo])
    else
        fprintf(FileID, '%9s %10s %10s %10s\n', 'Ensemble', 'MSE','SV', 'Diff');
        for i = 1:m
            g = sprintf('%d ', ensemble(i).ind_ens);
            fprintf(FileID,'%9s %10.5f  %10i %10.5f\n', g, ensemble(i).mse, ensemble(i).sv, ensemble(i).diff);
        end
    end
fclose(FileID);    
end

end