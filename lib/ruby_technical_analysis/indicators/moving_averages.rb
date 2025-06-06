module RubyTechnicalAnalysis
  # Moving Averages
  #
  # Find more information at:
  #
  # Simple Moving Average (SMA): https://www.fidelity.com/learning-center/trading-investing/technical-analysis/technical-indicator-guide/sma
  #
  # Exponential Moving Average (EMA): https://www.fidelity.com/learning-center/trading-investing/technical-analysis/technical-indicator-guide/ema
  #
  # Weighted Moving Average (WMA): https://www.fidelity.com/learning-center/trading-investing/technical-analysis/technical-indicator-guide/wma
  class MovingAverages < Indicator
    attr_reader :period

    # @param series [Array] An array of prices, typically closing prices
    # @param period [Integer] The number of periods to use in the calculation
    def initialize(series: [], period: 20)
      @period = period

      super(series: series)
    end

    # Simple Moving Average
    # @return [Float] The current SMA value
    def sma
      series.last(period).sum.to_f / period
    end

    # Exponential Moving Average
    # @return [Float] The current EMA value
    def ema
      return series.last if period == 1

      series.each_with_object([]) do |num, result|
        result << if result.empty?
          num
        else
          (num * _ema_percentages.first) + (result.last * _ema_percentages.last)
        end
      end.last
    end

    # Weighted Moving Average
    # @return [Float] The current WMA value
    def wma
      true_periods = (1..period).sum

      sigma_periods = series.last(period).each_with_index.sum { |num, index| (index + 1) * num }

      sigma_periods.to_f / true_periods
    end

    # @return [Boolean] Whether or not the object is valid
    def valid?
      period <= series.length
    end

    private

    def _ema_percentages
      @_ema_percentages ||=
        case period
        when 12 then [0.153846, 0.846154]
        when 26 then [0.074074, 0.925926]
        else
          last_obs_pct = 2.0 / (period + 1)

          [last_obs_pct, 1 - last_obs_pct]
        end
    end
  end
end
