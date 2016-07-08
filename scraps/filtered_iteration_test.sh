#!/bin/sh
echo
echo 'ruby filtered_iteration.rb'
ruby filtered_iteration.rb

echo
echo 'DESCRIBED_NAME_IS=Dave ruby filtered_iteration.rb'
DESCRIBED_NAME_IS=Dave ruby filtered_iteration.rb

echo
echo 'DESCRIBED_AGE_EQ=18 ruby filtered_iteration.rb'
DESCRIBED_AGE_EQ=18 ruby filtered_iteration.rb

echo
echo 'DESCRIBED_AGE_GT=18 ruby filtered_iteration.rb'
DESCRIBED_AGE_GT=18 ruby filtered_iteration.rb

echo
echo 'DESCRIBED_AGE_LE=18 ruby filtered_iteration.rb'
DESCRIBED_AGE_LE=18 ruby filtered_iteration.rb

echo
echo 'DESCRIBED_NAME_MATCHES=an ruby filtered_iteration.rb'
DESCRIBED_NAME_MATCHES=an ruby filtered_iteration.rb

echo
echo 'DESCRIBED_NAME_IMATCHES=an ruby filtered_iteration.rb'
DESCRIBED_NAME_IMATCHES=an ruby filtered_iteration.rb

echo
echo DESCRIBED_NAME_IMATCHES=\'^an\' ruby filtered_iteration.rb
DESCRIBED_NAME_IMATCHES='^an' ruby filtered_iteration.rb

echo
echo DESCRIBED_NAME_MATCHES=\'y$\' ruby filtered_iteration.rb
DESCRIBED_NAME_MATCHES='y$' ruby filtered_iteration.rb
