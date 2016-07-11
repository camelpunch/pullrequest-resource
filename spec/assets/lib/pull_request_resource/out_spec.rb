require_relative '../../../../assets/lib/pull_request_resource/out'

module PullRequestResource
  describe Out do
    context 'when the git repo has the pull request meta information' do
      context 'when acquiring a pull request' do
        context 'with bad params' do
          it 'returns an error when path is missing' do
            input = {'params' => { 'status' => 'pending' },
                     'source' => { 'repo' => 'jtarchie/test' }}
            out = Out.new(input, 'my/destination')
            expect(out.error).to include '`path` required in `params`'
          end

          it 'returns an error when the path does not exist' do
            input = {'params' => { 'status' => 'pending', 'path' => 'do not care' },
                     'source' => { 'repo' => 'jtarchie/test' }}
            out = Out.new(input, 'my/destination')
            expect(out.error).to include '`path` "do not care" does not exist'
          end

          context 'with unsupported statuses' do
            it 'returns an error with the supported ones' do
              input = {'params' => { 'status' => 'do not care', 'path' => 'resource' },
                       'source' => { 'repo' => 'jtarchie/test' }}
              out = Out.new(input, 'my/destination')
              expect(out.error).to include '`status` "do not care" is not supported -- only success, failure, error, or pending'
            end
          end
        end
      end
    end
  end
end
