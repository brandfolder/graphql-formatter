require 'spec_helper'

describe GraphQLFormatter do
  it 'Has a version number' do
    expect(GraphQLFormatter::VERSION).not_to be nil
  end

  it 'Properly formats a graphql statement' do
    q = %q{query Root_query{root{id,...__RelayQueryFragment0i8l90s}} fragment __RelayQueryFragment1pzx6jq on List{id,name} fragment __RelayQueryFragment0i8l90s on RootLevel{id,_listscr8cc8:lists(first:10,order:"-id"){edges{node{id,...__RelayQueryFragment1pzx6jq},cursor},pageInfo{hasNextPage,hasPreviousPage}}}}
    f = GraphQLFormatter.new(q)
    expect(f.to_s(colorize: false).lines.map(&:rstrip).join('\n')).to eq <<-output.lines.map(&:rstrip).join('\n')
query Root_query {
    root {
        id,
        ...__RelayQueryFragment0i8l90s
    }
}
fragment __RelayQueryFragment1pzx6jq on List {
    id,
    name
}
fragment __RelayQueryFragment0i8l90s on RootLevel {
    id,
    _listscr8cc8:lists(first: 10, order: "-id") {
        edges {
            node {
                id,
                ...__RelayQueryFragment1pzx6jq
            },
            cursor
        },
        pageInfo {
            hasNextPage,
            hasPreviousPage
        }
    }
}
    output
  end
end
