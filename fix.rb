# https://github.com/prawnpdf/prawn/issues/1203
module TTFunk
  class Table
    class Cff < TTFunk::Table
      class Charset < TTFunk::SubTable
        def encode(mapping)
          # no offset means no charset was specified (i.e. we're supposed to
          # use a predefined charset) so there's nothing to encode
          return '' unless offset

          sids = mapping.keys.sort.map { |new_gid| sid_for(mapping[new_gid]) }
          sids.delete(0) #.notdef should not be encoded
          ranges = TTFunk::BinUtils.rangify(sids)
          range_max = ranges.map(&:last).max

          range_bytes =
            if range_max.positive?
              (Math.log2(range_max) / 8).floor + 1
            else
              # for cases when there are no sequences at all
              Float::INFINITY
            end

          # calculate whether storing the charset as a series of ranges is
          # more efficient (i.e. takes up less space) vs storing it as an
          # array of SID values
          total_range_size = (2 * ranges.size) + (range_bytes * ranges.size)
          total_array_size = sids.size * element_width(:array_format)

          #if total_array_size <= total_range_size
            ([format_int(:array_format)] + sids).pack('Cn*')
          #else
          #  fmt = range_bytes == 1 ? :range_format8 : :range_format16
          #  element_fmt = element_format(fmt)
          #  result = [format_int(fmt)].pack('C')
          #  ranges.each { |range| result << range.pack(element_fmt) }
          #  result
          #end
        end
      end
    end
  end
end
