class BiHash
	def initialize
		@labels = Hash.new #{ |h, k| h[k] = [ ] }
		@columns = Hash.new #{ |h, k| h[k] = [ ] }
	end

	def insert(column, label)
		@labels[label] = column
		@columns[column] = label
	end

	def labelToColumn(label)
		fetch_from(@labels, label)
	end

	def columnToLabel(column)
		fetch_from(@columns, column)
	end
	
	def column?(col)
		@columns.key?(col)
	end 

	def label?(lab)
		@labels.key?(lab)
	end

	protected

	def fetch_from(h, k)
		return nil if(!h.has_key?(k))
		v = h[k]
		v.length == 1 ? v.first : v.dup
	end
end
