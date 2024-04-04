#ifdef FEATURE_METRICS
/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

	#include "metrics.hpp"
	#include "lib/di/container.hpp"

using namespace metrics;

Metrics &Metrics::getInstance() {
	return inject<Metrics>();
}

void Metrics::init(Options opts) {
	if (!opts.enableOStreamExporter && !opts.enablePrometheusExporter) {
		return;
	}

	auto provider = metrics_sdk::MeterProviderFactory::Create();
	auto* p = static_cast<metrics_sdk::MeterProvider*>(provider.get());

	if (opts.enableOStreamExporter) {
		opts.ostreamOptions.export_timeout_millis = std::chrono::milliseconds(1000);
		auto ostreamExporter = metrics_exporter::OStreamMetricExporterFactory::Create();
		auto reader = metrics_sdk::PeriodicExportingMetricReaderFactory::Create(std::move(ostreamExporter), opts.ostreamOptions);
		p->AddMetricReader(std::move(reader));
	}

	if (opts.enablePrometheusExporter) {
		g_logger().info("Starting Prometheus exporter at {}", opts.prometheusOptions.url);
		auto prometheusExporter = metrics_exporter::PrometheusExporterFactory::Create(opts.prometheusOptions);
		p->AddMetricReader(std::move(prometheusExporter));
	}

	metrics_api::Provider::SetMeterProvider(std::move(provider));
	initHistograms();
}

void Metrics::initHistograms() {
	for (auto name : latencyNames) {
		auto instrumentSelector = metrics_sdk::InstrumentSelectorFactory::Create(metrics_sdk::InstrumentType::kHistogram, name, "us");
		auto meterSelector = metrics_sdk::MeterSelectorFactory::Create("performance", otelVersion, otelSchema);

		auto aggregationConfig = std::make_unique<metrics_sdk::HistogramAggregationConfig>();
		// TODO: migrate to ExponentialHistogramIndexer when that's available
		// clang-format off
		aggregationConfig->boundaries_ = {
			// Ultra-fine granularity below 10µs
			0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0,
			12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0, 30.0,
			35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0,
			85.0, 90.0, 95.0, 100.0,
			// Fine granularity between 100µs and 500µs
			120.0, 140.0, 160.0, 180.0, 200.0, 225.0, 250.0, 275.0, 300.0, 325.0, 350.0, 375.0, 400.0, 425.0, 450.0, 475.0, 500.0,
			// Moderate granularity from 500µs to 1ms (1000µs)
			550.0, 600.0, 650.0, 700.0, 750.0, 800.0, 850.0, 900.0, 950.0, 1000.0,
			// Coarser granularity for higher latencies (in microseconds)
			1100.0, 1200.0, 1300.0, 1400.0, 1500.0, 2000.0, 2500.0, 3000.0, 3500.0, 4000.0, 4500.0, 5000.0, 10000.0,
			// Very coarse granularity for latencies in milliseconds
			20000.0, 30000.0, 40000.0, 50000.0, 60000.0,70000.0, 80000.0, 90000.0, 100000.0,
			200000.0, 300000.0, 400000.0, 500000.0, 600000.0,700000.0, 800000.0, 900000.0, 1000000.0,
			// Even coarser granularity for latencies in seconds
			2000000.0, 3000000.0, 4000000.0, 5000000.0, 6000000.0,7000000.0, 8000000.0, 9000000.0, 10000000.0,
			20000000.0, 30000000.0, 40000000.0, 50000000.0, 60000000.0,70000000.0, 80000000.0, 90000000.0, 100000000.0,
			// And finally a catch-all for anything else
			std::numeric_limits<double>::infinity(),
		};
		// clang-format on

		auto view = metrics_sdk::ViewFactory::Create(name, "Latency", "us", metrics_sdk::AggregationType::kHistogram, std::move(aggregationConfig));
		auto provider = metrics_api::Provider::GetMeterProvider();
		auto* p = static_cast<metrics_sdk::MeterProvider*>(provider.get());
		p->AddView(std::move(instrumentSelector), std::move(meterSelector), std::move(view));

		latencyHistograms[name] = getMeter()->CreateDoubleHistogram(name, "Latency", "us");
	}
}

void Metrics::shutdown() {
	std::shared_ptr<metrics_api::MeterProvider> none;
	metrics_api::Provider::SetMeterProvider(none);
}

ScopedLatency::ScopedLatency(std::string_view name, const std::string &histogramName, const std::string &scopeKey) :
	ScopedLatency(name, g_metrics().latencyHistograms[histogramName], { { scopeKey, std::string(name) } }, g_metrics().defaultContext) {
	if (histogram == nullptr) {
		stopped = true;
		return;
	}
}

ScopedLatency::~ScopedLatency() {
	stop();
}

void ScopedLatency::stop() {
	if (stopped) {
		return;
	}
	stopped = true;
	auto end = std::chrono::steady_clock::now();
	double elapsed = static_cast<double>(std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin).count()) / 1000;
	auto attrskv = opentelemetry::common::KeyValueIterableView<decltype(attrs)> { attrs };
	histogram->Record(elapsed, attrskv, context);
}

#endif // FEATURE_METRICS
