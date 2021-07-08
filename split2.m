function  varargout = split2( vec )
        assert( nargout == numel( vec )             ...
            ,   'split:narginNargoutMismatch'      ...     
         ,   'The number of outputs should match the length of the input vector.')
        varargout = num2cell( vec );
    end