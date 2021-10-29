FactoryBot.define do
  factory :session do
    operational_system { Session::OPERATIONAL_SYSTEMS.sample }
  end
end
