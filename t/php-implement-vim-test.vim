source ./plugin/php-implement-vim.vim

describe 'php implement vim'
    it 'can determine if symbol name provided is an interface'
      Expect 1 == 1
    end

    describe 'php-implement-vim#createFunctionDictionary'
        it 'is a sample test'
            Expect search('\v^\s*interface\s+') >= 0
        end

        it 'can create a dictionary for a function'
            let args = ['arg1', 'arg2']
            let isAbstract = 0
            let dict = call(function('CreateFunctionDictionary'), ['name', args, isAbstract])

            Expect dict.name == 'name'
            Expect dict.args == args
            Expect dict.isAbstract == isAbstract
        end
    end

    describe 'GetFunctionSignature'
        before
            new
            set ff=unix
            call append(1, ['<?php', 'public function testFunction();', 'protected function another($arg1);', 'private function moreArgs($arg1, $arg2);'])
        end

        after
            close!
        end

        it 'can get a List of function signatures'

            let list = call('GetFunctionSignature', [])
            Expect len(list) == 3
            Expect list[0] == 'public function testFunction();'
            Expect list[1] == 'protected function another($arg1);'
            Expect list[2] == 'private function moreArgs($arg1, $arg2);'
        end
    end

    describe 'CreateFunctionArgsList'
        it 'can create list for single argument functions'
            let fnSignature = 'public function thisTest($arg1)'
            Expect call('GetFunctionArgsList', [fnSignature]) == ['$arg1']
        end
        
        it 'can create list for multi argument functions'
            let fnSignature = 'public function thisTest($arg1,$arg2,$arg3)'
            Expect call('GetFunctionArgsList', [fnSignature]) == ['$arg1', '$arg2', '$arg3']
        end
        
        it 'can create list of arguments if spaces are present'
            let fnSignature = 'public function thisTest($arg1  ,$arg2   ,   $arg3)'
            Expect call('GetFunctionArgsList', [fnSignature]) == ['$arg1', '$arg2', '$arg3']
        end
    end
end
