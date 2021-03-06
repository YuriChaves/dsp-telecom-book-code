% Copyright (C) 1996, 1997, 1998, 2000, 2002, 2004, 2005, 2006, 2007
%               Kurt Hornik
%
% This file is part of Octave.
%
% Octave is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or (at
% your option) any later version.
%
% Octave is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Octave; see the file COPYING.  If not, see
% <http://www.gnu.org/licenses/>.
%
% -*- texinfo -*-
% @deftypefn {Function File} {} discrete_pdf (@var{x}, @var{v}, @var{p})
% For each element of @var{x}, compute the probability density function
% (PDF) at @var{x} of a univariate discrete distribution which assumes
% the values in @var{v} with probabilities @var{p}.
% @end deftypefn
%
% Author: KH <Kurt.Hornik@wu-wien.ac.at>
% Description: pDF of a discrete distribution

function pdf = octave_discrete_pdf (x, v, p)

if (nargin ~= 3)
    print_usage ();
end

sz = size (x);

if (~ isvector (v))
    error ('discrete_pdf: v must be a vector');
elseif (~ isvector (p) || (length (p) ~= length (v)))
    error ('discrete_pdf: p must be a vector with length (v) elements');
elseif (~ (all (p >= 0) && any (p)))
    error ('discrete_pdf: p must be a nonzero, nonnegative vector');
end

n = numel (x);
m = length (v);
x = reshape (x, n, 1);
v = reshape (v, 1, m);
p = reshape (p / sum (p), m, 1);

pdf = zeros (sz);
k = find (isnan (x));
if (any (k))
    pdf (k) = NaN;
end
k = find (~isnan (x));
if (any (k))
    n = length (k);
    pdf (k) = ((x(k) * ones (1, m)) == (ones (n, 1) * v)) * p;
end


