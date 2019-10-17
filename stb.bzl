def stb_library(name, emit_definition_macro = "", stb_prefix = True, copts = []):
  definition_name = "{}_definition".format(name)
  header_file_name = "{0}{1}.h".format("stb_" if stb_prefix else "", name)
  src_file_name = "{}_definition.cpp".format(name)
  if emit_definition_macro:
      # Generate the source file for lib compilation
      src_file_content = '#define {0}\n#include <stb/{1}>'.format(
          emit_definition_macro, header_file_name
      )
      native.genrule(
          name = definition_name,
          outs = [src_file_name],
          cmd  = 'echo "{0}" > $(@D)/{1}'.format(
              src_file_content, src_file_name
          ),
          visibility = ["//visibility:private"],
      )
  native.cc_library(
      name = name,
      hdrs = ["src/{}".format(header_file_name)],
      strip_include_prefix = "src",
      include_prefix = "stb",
      srcs = [src_file_name] if emit_definition_macro else [],
      copts = copts,
      visibility = ["//visibility:public"],
  )

