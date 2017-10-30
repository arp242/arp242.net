---
layout: post
title: Making FlagShihTzu work well with Formtastic
categories: programming-and-such
---

[FlagShihTzu][flag] & [Formtastic][formtastic] don’t work together
out-of-the-box, but this can be solved with a few lines of code.

There are a few ways to do this; here’s mine:

	class Spaceship < ActiveRecord::Base
		has_flags(
			1 => :warpdrive,
			2 => :shields,
			3 => :electrolytes,
			column: 'features',
		)

		# Allow easy assignment from formtastic as an Array; for example:
		# ['', '1', '', '3'] will set features to 4 (:warpdrive
		# and :electrolytes)
		def features_array= val
			self.features =
				if val.respond_to?(:reduce)
					val.reduce(0) { |memo, n| memo + n.to_i }
				else
					val
				end
		end

		# Get as an Array with all bits set as an int, ie:
		# [1, 3]
		# This allows easy use in formtastic
		def features_array
			features.to_s(2).split('').reverse
				.map.with_index { |bit, i| 2 ** i if bit == '1' }
				.compact
		end
	end

Now you can do this in your view:

	= f.input :features_array, as: :check_boxes,
		label: I18n.t('Which features does your spaceship have?'),
		collection: flag_to_collection(Spaceship, 'features')

And you may also want this little [helper][helpers]:

	def flag_to_collection model, col
		model::flag_mapping[col.to_s].map do |k, v|
			[I18n.t(k, scope: "activerecord.attributes.#{model.to_s.tableize.singularize}.#{col.pluralize}"), v]
		end
	end

P.S. Don’t forget to add `:features_array` to the
[StrongParameters][strong_params] if you’re using Rails 4.

[flag]: https://github.com/pboling/flag_shih_tzu
[formtastic]: https://github.com/justinfrench/formtastic
[strong_params]: http://api.rubyonrails.org/classes/ActionController/StrongParameters.html
[helpers]: http://api.rubyonrails.org/classes/ActionController/Helpers.html
