function svm_train_matlab(a)
% Função na tentativa de treinar a SVM usando o CUDA.
    if not(libisloaded('libthundersvm'))
        loadlibrary('../build/lib/libthundersvm', '../include/thundersvm/svm_matlab_interface.h') %localização da biblioteca no computador.
    end
	str = {'thundersvm-train'}
	str2 = [str a]
	x= calllib('libthundersvm', 'thundersvm_train_matlab', length(str2), str2)
end
