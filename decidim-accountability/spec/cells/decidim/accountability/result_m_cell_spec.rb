# frozen_string_literal: true

require "spec_helper"

module Decidim::Accountability
  describe ResultCell, type: :cell do
    controller Decidim::Accountability::ResultsController

    subject { cell_html }

    let(:start_date) { 3.days.ago }
    let(:end_date) { 3.days.from_now }
    let(:progress) { 67.0 }
    let!(:result) { create(:result, start_date:, end_date:, progress:) }
    let(:model) { result }
    let(:cell_html) { cell("decidim/accountability/result_m", result, context: { show_space: }).call }

    it_behaves_like "has space in m-cell"

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(subject).to have_css(".card--result")
      end

      it "renders the start and end time" do
        result_start = I18n.l(start_date.to_date, format: :decidim_short)
        result_end = I18n.l(end_date.to_date, format: :decidim_short)

        expect(subject).to have_css(".card-data__item--centerblock", text: result_start)
        expect(subject).to have_css(".card-data__item--centerblock", text: result_end)
      end

      it "renders the progress value and bar" do
        expect(subject).to have_content(/#{progress.to_i}%\s*Executed/)
        expect(subject).to have_css('[role="progressbar"]')
      end

      context "when start and end dates are blank" do
        let(:start_date) { nil }
        let(:end_date) { nil }

        it "hides dates block" do
          expect(subject).not_to have_css(".card-data__item--centerblock")
        end
      end

      context "when progress is blank" do
        let(:progress) { nil }

        it "hides progress value and bar" do
          expect(subject).not_to have_css('[role="progressbar"]')
        end
      end
    end
  end
end
