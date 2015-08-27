defprotocol Docopt.Node do
  def parse(node, args, arglist)
end

defimpl Docopt.Node, for: Any do
  require Logger

  def parse(tree, [], arg_list) do
    err = {:error,
           "Arg list ran out",
           [tree: tree, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  def parse(tree, argv, arg_list) do
    err = {:error,
           "I don't even know",
           [argv: argv, tree: tree, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end
end
